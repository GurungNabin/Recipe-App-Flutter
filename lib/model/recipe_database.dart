import 'package:recipe_book/model/irecipe.dart';

class LocalRecipe implements IRecipe {
  @override
  final int id;
  @override
  final String name;
  @override
  final List<String> tags;
  @override
  final String difficulty;
  final List<String> imagePaths;
  @override
  final double rating;
  @override
  final int reviewCount;
  @override
  final String cuisine;
  @override
  final int prepTimeMinutes;
  @override
  final int cookTimeMinutes;
  @override
  final int servings;
  @override
  final int caloriesPerServing;
  @override
  final List<String> ingredients;
  @override
  final List<String> instructions;
  @override
  final List<String> mealType;
  @override
  final int userId;

  LocalRecipe({
    required this.id,
    required this.name,
    required this.tags,
    required this.difficulty,
    required this.imagePaths,
    required this.rating,
    required this.reviewCount,
    required this.cuisine,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.caloriesPerServing,
    required this.ingredients,
    required this.instructions,
    required this.mealType,
    required this.userId,
  });

  @override
  String get image => imagePaths.isNotEmpty ? imagePaths.first : '';

  // factory LocalRecipe.fromMap(Map<String, dynamic> map) {
  //   return LocalRecipe(
  //     id: map['id'],
  //     name: map['name'],
  //     tags: List<String>.from(map['tags'].split(',')),
  //     difficulty: map['difficulty'],
  //     imagePaths: List<String>.from(map['imagePaths'].split(',')),
  //     rating: map['rating'],
  //     reviewCount: map['reviewCount'],
  //     cuisine: map['cuisine'],
  //     prepTimeMinutes: map['prepTimeMinutes'],
  //     cookTimeMinutes: map['cookTimeMinutes'],
  //     servings: map['servings'],
  //     caloriesPerServing: map['caloriesPerServing'],
  //     ingredients: List<String>.from(map['ingredients'].split(',')),
  //     instructions: List<String>.from(map['instructions'].split(',')),
  //     mealType: List<String>.from(map['mealType'].split(',')),
  //     userId: map['userId'],
  //   );
  // }

  factory LocalRecipe.fromMap(Map<String, dynamic> map) {
    return LocalRecipe(
      id: map['id'] is String ? int.parse(map['id']) : map['id'] as int,
      name: map['name'] as String,
      ingredients: (map['ingredients'] as String)
          .split(',')
          .map((e) => e.trim())
          .toList(),
      instructions: (map['instructions'] as String)
          .split(',')
          .map((e) => e.trim())
          .toList(),
      prepTimeMinutes: map['prepTimeMinutes'] is String
          ? int.parse(map['prepTimeMinutes'])
          : map['prepTimeMinutes'] as int,
      cookTimeMinutes: map['cookTimeMinutes'] is String
          ? int.parse(map['cookTimeMinutes'])
          : map['cookTimeMinutes'] as int,
      servings: map['servings'] is String
          ? int.parse(map['servings'])
          : map['servings'] as int,
      difficulty: map['difficulty'] as String,
      cuisine: map['cuisine'] as String,
      caloriesPerServing: map['caloriesPerServing'] is String
          ? int.parse(map['caloriesPerServing'])
          : map['caloriesPerServing'] as int,
      tags: (map['tags'] as String).split(',').map((e) => e.trim()).toList(),
      userId: map['userId'] is String
          ? int.parse(map['userId'])
          : map['userId'] as int,
      imagePaths: (map['imagePaths'] as String)
          .split(',')
          .map((e) => e.trim())
          .toList(),
      rating: map['rating'] is String
          ? double.parse(map['rating'])
          : (map['rating'] is int
              ? (map['rating'] as int).toDouble()
              : map['rating'] as double),
      reviewCount: map['reviewCount'] is String
          ? int.parse(map['reviewCount'])
          : map['reviewCount'] as int,
      mealType:
          (map['mealType'] as String).split(',').map((e) => e.trim()).toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tags': tags.join(','),
      'difficulty': difficulty,
      'imagePaths': imagePaths.join(','),
      'rating': rating,
      'reviewCount': reviewCount,
      'cuisine': cuisine,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'caloriesPerServing': caloriesPerServing,
      'ingredients': ingredients.join(','),
      'instructions': instructions.join(','),
      'mealType': mealType.join(','),
      'userId': userId,
    };
  }
}
