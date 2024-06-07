// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_lists/modal/FoodCreation/FoodCategories.dart';

Future<List<FoodCategories>> fetchFoodCategory(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final List<dynamic> categoriesJson = jsonResponse['categories'];
    return categoriesJson.map((json) => FoodCategories.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Food Category');
  }
}
