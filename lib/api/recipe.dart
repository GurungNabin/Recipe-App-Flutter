// import 'package:dio/dio.dart';
// import 'package:recipe_book/database/database.dart';
// import 'package:recipe_book/model/recipe_database.dart';

// import '../model/recipe.dart';

// class RecipeService {
//   final Dio _dio = Dio();
//   final DatabaseHelper _databaseHelper = DatabaseHelper();

//   Future<List<Recipe>> fetchRecipes() async {
//     try {
//       final response = await _dio.get('https://dummyjson.com/recipes');
//       if (response.statusCode == 200) {
//         List<dynamic> data = response.data['recipes'];
//         print('Fetched remote recipes: $data');
//         return data.map((json) => Recipe.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load recipes');
//       }
//     } catch (e) {
//       throw Exception('Failed to load recipes: $e');
//     }
//   }

//   Future<List<LocalRecipe>> fetchLocalRecipes() async {
//     try {
//       final localRecipes = await _databaseHelper.getRecipes();
//       // Add logging to inspect the fetched data
//       print('Fetched local recipes: $localRecipes');
//       return localRecipes;
//     } catch (e) {
//       throw Exception('Failed to load recipes: $e');
//     }
//   }

//   Future<void> addRecipe(LocalRecipe recipe) async {
//     try {
//       await _databaseHelper.insertRecipe(recipe);
//     } catch (e) {
//       throw Exception('Failed to add recipe: $e');
//     }
//   }

//   Future<List<dynamic>> fetchAllRecipes() async {
//     try {
//       final remoteRecipes = await fetchRecipes();
//       final localRecipes = await fetchLocalRecipes();
//       return [...remoteRecipes, ...localRecipes];
//     } catch (e) {
//       throw Exception('Failed to load recipes: $e');
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:recipe_book/database/database.dart';
import 'package:recipe_book/model/irecipe.dart';
import 'package:recipe_book/model/recipe_database.dart';

import '../model/recipe.dart';

class RecipeService {
  final Dio _dio = Dio();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await _dio.get('https://dummyjson.com/recipes');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['recipes'];
        // Add logging to inspect the fetched data
        print('Fetched remote recipes: $data');
        // Log the types of all fields in the first recipe
        if (data.isNotEmpty) {
          final firstRecipe = data[0];
          firstRecipe.forEach((key, value) {
            print('Field: $key, Type: ${value.runtimeType}');
          });
        }
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }

  Future<void> addRecipe(LocalRecipe recipe) async {
    try {
      await _databaseHelper.insertRecipe(recipe);
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  Future<List<LocalRecipe>> fetchLocalRecipes() async {
    try {
      final localRecipes = await _databaseHelper.getRecipes();
      // Add logging to inspect the fetched data
      print('Fetched local recipes: $localRecipes');
      if (localRecipes.isEmpty) {
        print('no local recipes in database');
        print('object $localRecipes');
      }
      return localRecipes;
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }

  Future<List<IRecipe>> fetchAllRecipes() async {
    try {
      final remoteRecipes = await fetchRecipes();
      final localRecipes = await fetchLocalRecipes();
      return [
        ...localRecipes,
        ...remoteRecipes,
      ];
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }
}
