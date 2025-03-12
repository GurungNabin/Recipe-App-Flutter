import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/presentation/bloc/pdf/pdf_bloc.dart';
import 'package:recipe_book/presentation/bloc/pdf/pdf_event.dart';
import 'package:recipe_book/presentation/bloc/pdf/pdf_state.dart';

import '../../../model/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(recipe.name),
        ),
        body: BlocListener<PdfBloc, PdfState>(
          listener: (context, state) {
            if (state is PdfLoading) {
              _showLoadingDialog(context);
            } else if (state is PdfGenerated) {
              Navigator.of(context).pop(); // Close the loading dialog
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showAlert(
                    context, 'Success', 'PDF saved to ${state.filePath}');
              });
            } else if (state is PdfError) {
              Navigator.of(context).pop(); // Close the loading dialog
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showAlert(context, 'Error', state.message);
              });
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(recipe.image),
                const SizedBox(height: 16),
                Text(
                  recipe.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Rating: ${recipe.rating} (${recipe.reviewCount} reviews)',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cuisine: ${recipe.cuisine}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Difficulty: ${recipe.difficulty}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Prep Time: ${recipe.prepTimeMinutes} minutes',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cook Time: ${recipe.cookTimeMinutes} minutes',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Servings: ${recipe.servings}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Calories per Serving: ${recipe.caloriesPerServing}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipe.ingredients.length,
                  itemBuilder: (context, index) {
                    return Text('- ${recipe.ingredients[index]}');
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Instructions:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipe.instructions.length,
                  itemBuilder: (context, index) {
                    return Text('- ${recipe.instructions[index]}');
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tags:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(recipe.tags.join(', ')),
                const SizedBox(height: 16),
                const Text(
                  'Meal Type:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(recipe.mealType.join(', ')),
              ],
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<PdfBloc>(context)
                    .add(GenerateRecipePdf(recipe));
              },
              child: const Icon(Icons.picture_as_pdf),
            );
          },
        ),
      ),
    );
  }
}
