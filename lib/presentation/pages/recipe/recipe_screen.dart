import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_book/bloc/recipe/recipe_event.dart';
import 'package:recipe_book/bloc/recipe/recipe_state.dart';
import 'package:recipe_book/presentation/pages/pdf_generate.dart';
import 'package:recipe_book/presentation/pages/recipe/add_recipe_screen.dart';
import 'package:recipe_book/presentation/pages/recipe/recipe_detail_screen.dart';
import 'package:recipe_book/widget/custom_card.dart';

class MyRecipeScreen extends StatefulWidget {
  const MyRecipeScreen({super.key});

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen> {
  Future<String>? _pdfGenerationFuture;

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(FetchRecipes());
  }

  void _showAlert(BuildContext context, String title, String message) {
    if (!mounted) return;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddRecipeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) {
              if (state is RecipeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RecipeError) {
                print('Error: ${state.message}');
                return Center(child: Text(state.message));
              } else if (state is RecipeLoaded) {
                final recipes = state.recipes ?? [];
                return recipes.isEmpty
                    ? const Center(
                        child: Text('No recipes available for local database.'))
                    : ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];

                          String imageUrl = recipe.image;
                          print('object of image is $imageUrl');

                          return CustomCard(
                            // imageUrl: File(imageUrl).toString(),
                            imageUrl: imageUrl,
                            name: recipe.name,
                            tags: recipe.tags,
                            difficulty: recipe.difficulty,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailScreen(recipe: recipe),
                                ),
                              );
                            },
                          );
                        },
                      );
              } else {
                return const Center(child: Text('No recipes available.'));
              }
            },
          ),
          if (_pdfGenerationFuture != null)
            FutureBuilder<String>(
              future: _pdfGenerationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Navigator.of(context).pop(); // Close the loading dialog
                  if (snapshot.hasError) {
                    print('Error I get is ${snapshot.error}');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showAlert(context, 'Error', snapshot.error.toString());
                    });
                  } else if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showAlert(
                          context, 'Success', 'PDF saved to ${snapshot.data}');
                    });
                  }
                  _pdfGenerationFuture = null; // Reset the future
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              final state = context.read<RecipeBloc>().state;
              if (state is RecipeLoaded) {
                _showLoadingDialog(context);
                setState(() {
                  _pdfGenerationFuture =
                      PdfGenerator.generateRecipeListPdf(state.recipes!);
                });
              }
            },
            child: const Icon(Icons.picture_as_pdf),
          );
        },
      ),
    );
  }
}
