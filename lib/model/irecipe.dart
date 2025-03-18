abstract class IRecipe {
  int get id;
  String get name;
  List<String> get ingredients;
  List<String> get instructions;
  int get prepTimeMinutes;
  int get cookTimeMinutes;
  int get servings;
  String get difficulty;
  String get cuisine;
  int get caloriesPerServing;
  List<String> get tags;
  int get userId;
  double get rating;
  int get reviewCount;
  List<String> get mealType;
  String get image; 

  Map<String, dynamic> toMap();
}
