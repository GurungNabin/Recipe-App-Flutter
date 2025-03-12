import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/api/movie.dart';
import 'package:recipe_book/api/recipe.dart';
import 'package:recipe_book/presentation/bloc/movie/movie_bloc.dart';
import 'package:recipe_book/presentation/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_book/presentation/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecipeBloc(RecipeService()),
        ),
        BlocProvider(
          create: (context) => MovieBloc(MovieServices()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}
