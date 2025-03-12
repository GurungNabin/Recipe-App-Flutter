import 'package:flutter/material.dart';
import 'package:recipe_book/presentation/pages/bottom_nav_bar.dart';
import 'package:recipe_book/presentation/pages/movies/movie_screen.dart';
import 'package:recipe_book/presentation/pages/post_screen.dart';
import 'package:recipe_book/presentation/pages/recipe/recipe_screen.dart';
import 'package:recipe_book/presentation/pages/search_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const RecipeBottomNavBar(
      items: [
        MyMovieScreen(),
        SearchScreen(),
        MyRecipeScreen(),
        MyPosts(),
      ],
    );
  }
}
