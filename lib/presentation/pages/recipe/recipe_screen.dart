// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:recipe_book/presentation/bloc/recipe/recipe_bloc.dart';
// import 'package:recipe_book/presentation/bloc/recipe/recipe_event.dart';
// import 'package:recipe_book/presentation/bloc/recipe/recipe_state.dart';
// import 'package:recipe_book/presentation/pages/pdf_generate.dart';
// import 'package:recipe_book/presentation/pages/recipe/recipe_detail_screen.dart';
// import 'package:recipe_book/widget/custom_card.dart';

// class MyRecipeScreen extends StatefulWidget {
//   const MyRecipeScreen({super.key});

//   @override
//   State<MyRecipeScreen> createState() => _MyRecipeScreenState();
// }

// class _MyRecipeScreenState extends State<MyRecipeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<RecipeBloc>().add(FetchRecipes());
//   }

//   void _showAlert(BuildContext context, String title, String message) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recipes'),
//       ),
//       body: BlocBuilder<RecipeBloc, RecipeState>(
//         builder: (context, state) {
//           if (state is RecipeLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is RecipeError) {
//             return Center(child: Text(state.message));
//           } else if (state is RecipeLoaded) {
//             return ListView.builder(
//               itemCount: state.recipes!.length,
//               itemBuilder: (context, index) {
//                 final recipe = state.recipes![index];
//                 return CustomCard(
//                   imageUrl: recipe.image,
//                   name: recipe.name,
//                   tags: recipe.tags,
//                   difficulty: recipe.difficulty,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             RecipeDetailScreen(recipe: recipe),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text('No recipes available.'));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final state = context.read<RecipeBloc>().state;
//           if (state is RecipeLoaded) {
//             final filePath =
//                 await PdfGenerator.generateRecipeListPdf(state.recipes!);
//             _showAlert(context, 'Success', 'PDF saved to $filePath');
//           }
//         },
//         child: const Icon(Icons.download),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/presentation/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_book/presentation/bloc/recipe/recipe_event.dart';
import 'package:recipe_book/presentation/bloc/recipe/recipe_state.dart';
import 'package:recipe_book/presentation/pages/pdf_generate.dart';
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
      ),
      body: Stack(
        children: [
          BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) {
              if (state is RecipeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RecipeError) {
                return Center(child: Text(state.message));
              } else if (state is RecipeLoaded) {
                return ListView.builder(
                  itemCount: state.recipes!.length,
                  itemBuilder: (context, index) {
                    final recipe = state.recipes![index];
                    return CustomCard(
                      imageUrl: recipe.image,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final state = context.read<RecipeBloc>().state;
          if (state is RecipeLoaded) {
            _showLoadingDialog(context); // Show loading dialog immediately
            setState(() {
              _pdfGenerationFuture =
                  PdfGenerator.generateRecipeListPdf(state.recipes!);
            });
          }
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
