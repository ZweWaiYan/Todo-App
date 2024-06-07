// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_lists/api/food/Category.dart';
import 'package:to_do_lists/api/food/MainIngredient.dart';
import 'package:to_do_lists/api/food/Random.dart';
import 'package:to_do_lists/components/food/GridItem.dart';
import 'package:to_do_lists/components/food/RandomItem.dart';
import 'package:to_do_lists/components/food/SideItem.dart';
import 'package:to_do_lists/modal/FoodCreation/FoodCategories.dart';
import 'package:to_do_lists/modal/FoodCreation/FoodMainIngredient.dart';
import 'package:to_do_lists/modal/FoodCreation/FoodRandom.dart';

class Foodpage extends StatefulWidget {
  const Foodpage({super.key});

  @override
  State<Foodpage> createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  final http.Client httpClient = http.Client();
  late Future<List<FoodCategories>> foodCategories;
  late Future<List<FoodMainIngredient>> foodMainIngredient;
  late Future<FoodRandom> foodRandom;

  @override
  void initState() {
    super.initState();
    foodMainIngredient = fetchMainIngredientJson(httpClient);
    foodCategories = fetchFoodCategory(httpClient);
    foodRandom = fetchRandomJson(httpClient);
  }

  @override
  void dispose() {
    httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Good Morning',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              iconSize: 35,
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 40,
                height: 40,
                child: InkWell(
                  onTap: () {},
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: 70,
                child: FutureBuilder<List<FoodCategories>>(
                  future: foodCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No categories available'));
                    } else {
                      return Center(
                          child: SideItem(foodCategories: snapshot.data!));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 10),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Today Special Menu',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            FutureBuilder<FoodRandom>(
              future: foodRandom,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return RandomItem(foodRandom: snapshot.data!);
                }
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 10),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Popular Menu',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<FoodMainIngredient>>(
                future: foodMainIngredient,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No categories available'));
                  } else {
                    // List<FoodMainIngredient> categoriesToShow =
                    //     snapshot.data!.take(12).toList();
                    return Center(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        // physics: const NeverScrollableScrollPhysics(),
                        // children: categoriesToShow
                        //     .map((mainIngredient) =>
                        //         GridItem(mainIngredient: mainIngredient))
                        //     .toList(),
                        children: snapshot.data!
                            .map((mainIngredient) =>
                                GridItem(mainIngredient: mainIngredient))
                            .toList(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const Foodpage());
}

//TODO
//review the code.
//check responsive UI with every device.
//Use this api ('//www.themealdb.com/api/json/v1/1/random.php') for slide showing.
//Reference -> https://chatgpt.com/c/4f23b89d-56e5-4297-9bde-caa682ffa864

//Fix
//When image loading is not finished, don't show text
