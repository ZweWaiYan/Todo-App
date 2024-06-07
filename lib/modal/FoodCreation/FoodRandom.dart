// ignore_for_file: file_names

class FoodRandom {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strCategory;

  const FoodRandom({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strCategory,
  });

  factory FoodRandom.fromJson(Map<String, dynamic> json) {
    return FoodRandom(
        idMeal: json['idMeal'] as String,
        strMeal: json['strMeal'] as String,
        strMealThumb: json['strMealThumb'] as String,
        strCategory: json['strCategory'] as String);
  }
}
