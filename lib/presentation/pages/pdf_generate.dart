import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:recipe_book/model/recipe.dart';
import 'package:recipe_book/model/recipe_database.dart';

class PdfGenerator {
  static Future<String> generatePdf(dynamic recipe) async {
    final pdf = pw.Document();

    String imageUrl;
    if (recipe is LocalRecipe) {
      imageUrl = recipe.imagePaths[0];
    } else if (recipe is Recipe) {
      imageUrl = recipe.image;
    } else {
      throw Exception('Unsupported recipe type');
    }

    pw.ImageProvider? pdfImage;
    if (imageUrl.startsWith('http')) {
      // Network image
      final response = await Dio()
          .get(imageUrl, options: Options(responseType: ResponseType.bytes));
      pdfImage = pw.MemoryImage(response.data);
    } else {
      // Local file image
      final file = File(imageUrl);
      if (await file.exists()) {
        pdfImage = pw.MemoryImage(file.readAsBytesSync());
      }
    }

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (pdfImage != null)
                  pw.Image(pdfImage, height: 100, width: 100),
                pw.SizedBox(height: 8),
                pw.Text(recipe.name,
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text(
                    'Rating: ${recipe.rating} (${recipe.reviewCount} reviews)',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Cuisine: ${recipe.cuisine}',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Difficulty: ${recipe.difficulty}',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Prep Time: ${recipe.prepTimeMinutes} minutes',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Cook Time: ${recipe.cookTimeMinutes} minutes',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Servings: ${recipe.servings}',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Calories per Serving: ${recipe.caloriesPerServing}',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 8),
                pw.Text('Ingredients:',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                ...recipe.ingredients.map((ingredient) => pw.Text(
                    '- $ingredient',
                    style: const pw.TextStyle(fontSize: 12))),
                pw.SizedBox(height: 8),
                pw.Text('Instructions:',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                ...recipe.instructions.map((instruction) => pw.Text(
                    '- $instruction',
                    style: const pw.TextStyle(fontSize: 12))),
                pw.SizedBox(height: 8),
                pw.Text('Tags:',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(recipe.tags.join(', '),
                    style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 8),
                pw.Text('Meal Type:',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(recipe.mealType.join(', '),
                    style: const pw.TextStyle(fontSize: 12)),
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

  static Future<String> generateRecipeListPdf(List<dynamic> recipes) async {
    final pdf = pw.Document();

    final images = await Future.wait(recipes.map((recipe) async {
      String imageUrl =
          recipe is LocalRecipe ? recipe.imagePaths[0] : recipe.image;
      pw.ImageProvider? pdfImage;

      if (imageUrl.startsWith('http')) {
        // Network image
        final response = await Dio()
            .get(imageUrl, options: Options(responseType: ResponseType.bytes));
        pdfImage = pw.MemoryImage(response.data);
      } else {
        // Local file image
        final file = File(imageUrl);
        if (await file.exists()) {
          pdfImage = pw.MemoryImage(file.readAsBytesSync());
        }
      }

      return pdfImage;
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
                        height: 25,
                        width: 25,
                        child: images[index] != null
                            ? pw.Image(images[index]!)
                            : pw.Container(),
                      ),
                      pw.Text(recipe.name,
                          style: const pw.TextStyle(fontSize: 12)),
                      pw.Text(recipe.cuisine,
                          style: const pw.TextStyle(fontSize: 12)),
                      pw.Text(recipe.difficulty,
                          style: const pw.TextStyle(fontSize: 12)),
                      pw.Text(
                          '${recipe.rating} (${recipe.reviewCount} reviews)',
                          style: const pw.TextStyle(fontSize: 12)),
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
