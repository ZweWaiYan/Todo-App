import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_lists/modal/Tasks.dart';
import 'package:to_do_lists/page/Tasks/DetailPage.dart';
import 'package:to_do_lists/page/Tasks/Listspage.dart';
import 'package:to_do_lists/page/Tasks/MarkedPage.dart';
import 'package:to_do_lists/page/Photo/PhotoListPage.dart';
import 'package:to_do_lists/page/food/foodPage.dart';

void main() {
  runApp(const Foodpage());
}

//Task main App
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Tasks>(
      create: (context) => Tasks(),
      child: MaterialApp(
        title: 'To Do Lists',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              iconTheme: IconThemeData(color: Colors.white)),
        ),
        initialRoute: '/',
        routes: {
          ListsPage.routeName: (context) => const ListsPage(),
          DetailPage.routeName: (context) => const DetailPage(),
          MarkedPage.routeName: (context) => const MarkedPage(),
        },
      ),
    );
  }
}
