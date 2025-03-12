import 'package:dio/dio.dart';

import '../model/recipe.dart';

class RecipeService {
  final Dio _dio = Dio();

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await _dio.get('https://dummyjson.com/recipes');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['recipes'];
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }
}
