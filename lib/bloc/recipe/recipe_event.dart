import 'package:recipe_book/model/recipe_database.dart';

abstract class RecipeEvent {}

class FetchRecipes extends RecipeEvent {}

class AddRecipe extends RecipeEvent {
  final LocalRecipe recipe;

  AddRecipe(this.recipe);
}
