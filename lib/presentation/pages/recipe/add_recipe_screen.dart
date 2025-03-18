import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recipe_book/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_book/bloc/recipe/recipe_event.dart';
import 'package:recipe_book/model/recipe_database.dart';
import 'package:uuid/uuid.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tagsController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _ratingController = TextEditingController();
  final _reviewCountController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _mealTypeController = TextEditingController();
  // File? _image;
  List<File> _images = [];

  @override
  void dispose() {
    _nameController.dispose();
    _tagsController.dispose();
    _difficultyController.dispose();
    _ratingController.dispose();
    _reviewCountController.dispose();
    _cuisineController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _caloriesController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _mealTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      print("Permission Denied");
      return;
    }
    print("Image Picker Triggered");

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final localRecipe = LocalRecipe(
        id: int.parse(const Uuid().v4().replaceAll('-', '').substring(0, 15),
            radix: 16),
        name: _nameController.text,
        tags: _tagsController.text.split(','),
        difficulty: _difficultyController.text,
        imagePaths: _images.map((file) => file.path).toList(),
        rating: double.parse(_ratingController.text),
        reviewCount: int.parse(_reviewCountController.text),
        cuisine: _cuisineController.text,
        prepTimeMinutes: int.parse(_prepTimeController.text),
        cookTimeMinutes: int.parse(_cookTimeController.text),
        servings: int.parse(_servingsController.text),
        caloriesPerServing: int.parse(_caloriesController.text),
        ingredients: _ingredientsController.text.split(','),
        instructions: _instructionsController.text.split(','),
        mealType: _mealTypeController.text.split(','),
        userId: -1,
      );

      context.read<RecipeBloc>().add(AddRecipe(localRecipe));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImages,
                child: _images.isEmpty
                    ? Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo, size: 50),
                      )
                    : SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _images.map((image) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(image,
                                  width: 150, fit: BoxFit.cover),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tagsController,
                decoration:
                    const InputDecoration(labelText: 'Tags (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tags';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _difficultyController,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter difficulty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reviewCountController,
                decoration: const InputDecoration(labelText: 'Review Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the review count';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cuisineController,
                decoration: const InputDecoration(labelText: 'Cuisine'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cuisine';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prepTimeController,
                decoration:
                    const InputDecoration(labelText: 'Prep Time (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the prep time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cookTimeController,
                decoration:
                    const InputDecoration(labelText: 'Cook Time (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cook time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _servingsController,
                decoration: const InputDecoration(labelText: 'Servings'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the servings';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _caloriesController,
                decoration:
                    const InputDecoration(labelText: 'Calories per Serving'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the calories per serving';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                    labelText: 'Ingredients (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ingredients';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                    labelText: 'Instructions (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the instructions';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mealTypeController,
                decoration: const InputDecoration(
                    labelText: 'Meal Type (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the meal type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
