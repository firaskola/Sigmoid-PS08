import 'package:flutter/material.dart';
import 'package:mediassist/screens/home/categories/customcard.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // AppBar height
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
          child: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text("Categories"),
            centerTitle: true,
          ),
        ),
      ),
      body: const Center(
        child: CardListView(),
      ),
    );
  }
}
