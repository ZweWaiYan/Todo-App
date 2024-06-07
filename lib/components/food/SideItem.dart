// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:to_do_lists/modal/FoodCreation/FoodCategories.dart';

class SideItem extends StatelessWidget {
  const SideItem({super.key, required this.foodCategories});

  final List<FoodCategories> foodCategories;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: foodCategories.map((category) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 45,
                  child: Image.network(
                    category.strCategoryThumb,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Text(
                    category.strCategory,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
