// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:recipe_book/api/recipe.dart';

// import 'recipe_event.dart';
// import 'recipe_state.dart';

// class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
//   final RecipeService recipeService;

//   RecipeBloc(this.recipeService) : super(RecipeInitial()) {
//     on<FetchRecipes>(_onFetchRecipes);
//     on<AddRecipe>(_onAddRecipe);
//   }

//   void _onFetchRecipes(FetchRecipes event, Emitter<RecipeState> emit) async {
//     emit(RecipeLoading());
//     try {
//       final recipes = await recipeService.fetchRecipes();
//       emit(RecipeLoaded(recipes));
//     } catch (e) {
//       emit(RecipeError('Failed to load recipes: $e'));
//     }
//   }

//   void _onAddRecipe(AddRecipe event, Emitter<RecipeState> emit) async {
//     emit(RecipeLoading());
//     try {
//       await recipeService.addRecipe(event.recipe);
//       final recipes = await recipeService.fetchRecipes();
//       emit(RecipeLoaded(recipes));
//     } catch (e) {
//       emit(RecipeError('Failed to add recipe: $e'));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/api/recipe.dart';
import 'package:recipe_book/bloc/recipe/recipe_event.dart';
import 'package:recipe_book/bloc/recipe/recipe_state.dart';
import 'package:recipe_book/model/irecipe.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeService recipeService;

  RecipeBloc(this.recipeService) : super(RecipeInitial()) {
    on<FetchRecipes>(_onFetchRecipes);
    on<AddRecipe>(_onAddRecipe);
  }

  void _onFetchRecipes(FetchRecipes event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      // final recipes = await recipeService.fetchAllRecipes();
      final List<IRecipe> allRecipes = await recipeService.fetchAllRecipes();
      emit(RecipeLoaded(allRecipes));
    } catch (e) {
      emit(RecipeError('Failed to load recipes: $e'));
    }
  }

  void _onAddRecipe(AddRecipe event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      await recipeService.addRecipe(event.recipe);
      final List<IRecipe> allRecipes = await recipeService.fetchAllRecipes();
      emit(RecipeLoaded(allRecipes));
    } catch (e) {
      emit(RecipeError('Failed to add recipe: $e'));
    }
  }
}
