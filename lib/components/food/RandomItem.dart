import 'package:flutter/material.dart';
import 'package:to_do_lists/modal/FoodCreation/FoodRandom.dart';

class RandomItem extends StatelessWidget {
  const RandomItem({super.key, required this.foodRandom});

  final FoodRandom foodRandom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      height: 190,
      child: Card(
        color: Colors.grey,
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 300,
                child: Card(
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    foodRandom.strMealThumb,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      foodRandom.strMeal,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'See more..',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
