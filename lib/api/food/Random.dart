// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_do_lists/modal/FoodCreation/FoodRandom.dart';

Future<FoodRandom> fetchRandomJson(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final dynamic randomJson = jsonResponse['meals'][0];
    return FoodRandom.fromJson(randomJson);
  } else {
    throw Exception('Failed to load Main Ingredient');
  }
}
