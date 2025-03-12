import 'package:recipe_book/model/recipe.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe>? recipes;

  RecipeLoaded( this.recipes);
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);
}