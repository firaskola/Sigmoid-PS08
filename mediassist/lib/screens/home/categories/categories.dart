import 'package:flutter/material.dart';
import 'package:mediassist/screens/home/categories/customcard.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: CardListView(),
      ),
    );
  }
}
