import 'package:path/path.dart';
import 'package:recipe_book/model/recipe_database.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recipe_book.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE recipes ADD COLUMN imagePaths TEXT');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY,
        name TEXT,
        ingredients TEXT,
        instructions TEXT,
        prepTimeMinutes INTEGER,
        cookTimeMinutes INTEGER,
        servings INTEGER,
        difficulty TEXT,
        cuisine TEXT,
        caloriesPerServing INTEGER,
        tags TEXT,
        userId INTEGER,
        imagePaths TEXT,
        rating INTEGER,
        reviewCount INTEGER,
        mealType TEXT
      )
    ''');
  }

  Future<void> insertRecipe(LocalRecipe recipe) async {
    final db = await database;
    await db.insert(
      'recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LocalRecipe>> getRecipes() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('recipes');

      print('Query result : $maps');
      return List.generate(maps.length, (i) {
        return LocalRecipe.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error querying recipes: $e');
      return [];
    }
  }
}
