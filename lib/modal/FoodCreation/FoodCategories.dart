class FoodCategories {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  const FoodCategories({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory FoodCategories.fromJson(Map<String, dynamic> json) {
    return FoodCategories(
      idCategory: json['idCategory'] as String,
      strCategory: json['strCategory'] as String,
      strCategoryThumb: json['strCategoryThumb'] as String,
      strCategoryDescription: json['strCategoryDescription'] as String,
    );
  }
}
