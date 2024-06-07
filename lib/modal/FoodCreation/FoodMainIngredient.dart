// ignore_for_file: file_names

class FoodMainIngredient {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  const FoodMainIngredient({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory FoodMainIngredient.fromJson(Map<String, dynamic> json) {
    return FoodMainIngredient(
        idMeal: json['idMeal'] as String,
        strMeal: json['strMeal'] as String,
        strMealThumb: json['strMealThumb'] as String);
  }
}
