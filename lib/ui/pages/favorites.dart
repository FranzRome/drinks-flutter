import 'package:cocktails/models/drink_model.dart';
import 'package:flutter/material.dart';

import '../../globals/local_data.dart';
import '../components/custom_tile.dart';

class Favorites extends StatefulWidget {
  final List<DrinkModel> drinks;

  const Favorites({super.key, required this.drinks});

  @override
  State createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late final List<DrinkModel> favorites;

  @override
  void initState() {
    favorites = getFavorites(widget.drinks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            child: /*widget.drinks.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 38),
                    child: Text(
                      'The list is empty\nPress the button to add a new drink',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              :*/
                Column(
              children: favorites
                  .map(
                    (drink) => CustomTile(
                        drink: drink,
                        onBack: (id) {
                          //onBack(drink.id);
                        }),
                  )
                  .toList(),
            )
            //   ListView.builder(
            // itemCount: filteredDrinks.length,
            // itemBuilder: (context, index) {
            //   DrinkEntity drink = filteredDrinks[index];
            //   return CustomTile(
            //       drink: drink,
            //       onBack: (id) {
            //         onBack(drink.id);
            //       });
            //}
            ),
      ),
    );
  }
}
