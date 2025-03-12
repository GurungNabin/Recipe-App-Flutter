import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recipe_book/model/movie.dart';

class MovieServices {
  final Dio _dio = Dio();

  Future<List<Movie>> fetchMovies() async {
    try {
      final response = await _dio.get('https://freetestapi.com/api/v1/movies');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      debugPrint("Error: $e"); // Add debug print for error
      throw Exception('Failed to load movies: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await _dio.get('https://freetestapi.com/api/v1/movies',
          queryParameters: {'search': query});
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      debugPrint("Error: $e"); // Add debug print for error
      throw Exception('Failed to search movies: $e');
    }
  }
}
