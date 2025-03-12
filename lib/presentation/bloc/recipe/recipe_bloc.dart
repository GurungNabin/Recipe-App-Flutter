import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/api/recipe.dart';

import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeService recipeService;

  RecipeBloc(this.recipeService) : super(RecipeInitial()) {
    on<FetchRecipes>(_onFetchRecipes);
  }

  void _onFetchRecipes(FetchRecipes event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      final recipes = await recipeService.fetchRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to load recipes: $e'));
    }
  }
}
