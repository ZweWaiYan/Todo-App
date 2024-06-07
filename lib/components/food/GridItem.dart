import 'package:flutter/material.dart';
import 'package:to_do_lists/modal/FoodCreation/FoodMainIngredient.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.mainIngredient});

  final FoodMainIngredient mainIngredient;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          child: Image.network(
            mainIngredient.strMealThumb,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            mainIngredient.strMeal,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
