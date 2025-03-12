import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:recipe_book/model/recipe.dart';

class PdfGenerator {
  static Future<String> generatePdf(Recipe recipe) async {
    final pdf = pw.Document();

    final response = await Dio()
        .get(recipe.image, options: Options(responseType: ResponseType.bytes));
    final image = pw.MemoryImage(response.data);

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(image),
                pw.SizedBox(height: 16),
                pw.Text(recipe.name,
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 16),
                pw.Text(
                    'Rating: ${recipe.rating} (${recipe.reviewCount} reviews)',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text('Cuisine: ${recipe.cuisine}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text('Difficulty: ${recipe.difficulty}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text('Prep Time: ${recipe.prepTimeMinutes} minutes',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text('Cook Time: ${recipe.cookTimeMinutes} minutes',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text('Servings: ${recipe.servings}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text('Calories per Serving: ${recipe.caloriesPerServing}',
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 16),
                pw.Text('Ingredients:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...recipe.ingredients
                    .map((ingredient) => pw.Text('- $ingredient')),
                pw.SizedBox(height: 16),
                pw.Text('Instructions:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...recipe.instructions
                    .map((instruction) => pw.Text('- $instruction')),
                pw.SizedBox(height: 16),
                pw.Text('Tags:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text(recipe.tags.join(', ')),
                pw.SizedBox(height: 16),
                pw.Text('Meal Type:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text(recipe.mealType.join(', ')),
              ],
            )
          ];
        },
      ),
    );

    final directory = Directory('/storage/emulated/0/Download/Recipe');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final file = File('${directory.path}/recipe_${recipe.name}.pdf');
    await file.writeAsBytes(await pdf.save());
    print('PDF saved to ${file.path}');
    return file.path;
  }

  static Future<String> generateRecipeListPdf(List<Recipe> recipes) async {
    final pdf = pw.Document();

    // Load images for all recipes
    final images = await Future.wait(recipes.map((recipe) async {
      final response = await Dio().get(recipe.image,
          options: Options(responseType: ResponseType.bytes));
      return pw.MemoryImage(response.data);
    }).toList());

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Image',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Name',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Cuisine',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Difficulty',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Rating',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                ...List<pw.TableRow>.generate(recipes.length, (index) {
                  final recipe = recipes[index];
                  return pw.TableRow(
                    children: [
                      pw.Container(
                        height: 50,
                        width: 50,
                        child: pw.Image(images[index]),
                      ),
                      pw.Text(recipe.name),
                      pw.Text(recipe.cuisine),
                      pw.Text(recipe.difficulty),
                      pw.Text(
                          '${recipe.rating} (${recipe.reviewCount} reviews)'),
                    ],
                  );
                }),
              ],
            ),
          ];
        },
      ),
    );

    final directory = Directory('/storage/emulated/0/Download/Recipe');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final file = File('${directory.path}/recipe_list.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
