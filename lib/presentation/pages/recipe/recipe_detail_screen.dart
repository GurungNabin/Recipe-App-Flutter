// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:recipe_book/bloc/pdf/pdf_bloc.dart';
// import 'package:recipe_book/bloc/pdf/pdf_event.dart';
// import 'package:recipe_book/bloc/pdf/pdf_state.dart';

// class RecipeDetailScreen extends StatelessWidget {
//   final dynamic recipe;

//   const RecipeDetailScreen({super.key, required this.recipe});
//   void _showAlert(BuildContext context, String title, String message) {
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

//   void _showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PdfBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(recipe.name),
//         ),
//         body: BlocListener<PdfBloc, PdfState>(
//           listener: (context, state) {
//             if (state is PdfLoading) {
//               _showLoadingDialog(context);
//             } else if (state is PdfGenerated) {
//               Navigator.of(context).pop();
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 _showAlert(
//                     context, 'Success', 'PDF saved to ${state.filePath}');
//               });
//             } else if (state is PdfError) {
//               Navigator.of(context).pop();
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 _showAlert(context, 'Error', state.message);
//                 print(
//                     'The object error thrown is  ${state.message.toString()}');
//               });
//             }
//           },
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 recipe.image.isNotEmpty
//                     ? SizedBox(
//                         width: double.infinity,
//                         height: 200,
//                         child: recipe.image.startsWith('http')
//                             ? Image.network(
//                                 recipe.image,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Image.asset(
//                                     'assets/default_recipe.png',
//                                     fit: BoxFit.cover,
//                                   );
//                                 },
//                               )
//                             : Image.file(
//                                 File(recipe.image),
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Image.asset(
//                                     'assets/default_recipe.png',
//                                     fit: BoxFit.cover,
//                                   );
//                                 },
//                               ),
//                       )
//                     : Image.asset(
//                         'assets/default_recipe.png',
//                         width: double.infinity, // Adjust the width as needed
//                         height: 200, // Adjust the height as needed
//                         fit: BoxFit.cover,
//                       ),
//                 const SizedBox(height: 16),
//                 Text(
//                   recipe.name,
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Rating: ${recipe.rating} (${recipe.reviewCount} reviews)',
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Cuisine: ${recipe.cuisine}',
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Difficulty: ${recipe.difficulty}',
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Prep Time: ${recipe.prepTimeMinutes} minutes',
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Cook Time: ${recipe.cookTimeMinutes} minutes',
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Servings: ${recipe.servings}',
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Calories per Serving: ${recipe.caloriesPerServing}',
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Ingredients:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: recipe.ingredients.length,
//                   itemBuilder: (context, index) {
//                     return Text('- ${recipe.ingredients[index]}');
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Instructions:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: recipe.instructions.length,
//                   itemBuilder: (context, index) {
//                     return Text('- ${recipe.instructions[index]}');
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Tags:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(recipe.tags.join(', ')),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Meal Type:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(recipe.mealType.join(', ')),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: Builder(
//           builder: (context) {
//             return FloatingActionButton(
//               onPressed: () async {
//                 // await _requestPermissions();
//                 BlocProvider.of<PdfBloc>(context)
//                     .add(GenerateRecipePdf(recipe));
//               },
//               child: const Icon(Icons.picture_as_pdf),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/bloc/pdf/pdf_bloc.dart';
import 'package:recipe_book/bloc/pdf/pdf_event.dart';
import 'package:recipe_book/bloc/pdf/pdf_state.dart';

class RecipeDetailScreen extends StatelessWidget {
  final dynamic recipe;

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
                print(
                    'The object error thrown is  ${state.message.toString()}');
              });
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                recipe.imagePaths.isNotEmpty
                    ? SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: recipe.imagePaths.map<Widget>((imagePath) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: imagePath.startsWith('http')
                                  ? Image.network(
                                      imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/default_recipe.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.file(
                                      File(imagePath),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/default_recipe.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                            );
                          }).toList(),
                        ),
                      )
                    : Image.asset(
                        'assets/default_recipe.png',
                        width: double.infinity, // Adjust the width as needed
                        height: 200, // Adjust the height as needed
                        fit: BoxFit.cover,
                      ),
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
              onPressed: () async {
                // await _requestPermissions();
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
