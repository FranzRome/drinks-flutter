import 'package:cocktails/cocktail_list/cocktail_list_tile.dart';
import 'package:cocktails/entities/cocktail_entity.dart';
import 'package:flutter/material.dart';

class CocktailList extends StatefulWidget {
  const CocktailList(this.cocktails, {super.key});

  final List<CocktailEntity> cocktails;

  @override
  State<CocktailList> createState() => CocktailListState(cocktails);
}

class CocktailListState extends State<CocktailList> {
  CocktailListState(this.cocktails);

  final List<CocktailEntity> cocktails;
  List<CocktailEntity> filteredCocktails = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      child: filteredCocktails.isEmpty
          ? const Center(
              child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 38),
              child: Text(
                'Type in the search bar to look for some cocktails',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ))
          : ListView.builder(
              itemCount: filteredCocktails.length,
              itemBuilder: (context, index) {
                return CocktailListTile(filteredCocktails[index]);
              }),
    );
  }

  void filterCocktails({String filter = ''}) {
    setState(() {
      if (filter == '') return filteredCocktails.clear();
      filteredCocktails = cocktails
          .where((element) =>
              element.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    });
  }
}
