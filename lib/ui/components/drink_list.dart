import 'package:cocktails/entities/drink_entity.dart';
import 'package:cocktails/ui/components/custom_tile.dart';
import 'package:flutter/material.dart';

class DrinkList extends StatefulWidget {
  const DrinkList({
    Key? key,
    required this.drinks,
    required this.onBack,
  }) : super(key: key);

  final List<DrinkEntity> drinks;
  final void Function(int id) onBack;

  @override
  State<DrinkList> createState() => DrinkListState();
}

class DrinkListState extends State<DrinkList> {
  List<DrinkEntity> filteredDrinks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            :*/ filteredDrinks.isEmpty
            ? ListView.builder(
          itemCount: widget.drinks.length,
          itemBuilder: (context, index) {
            DrinkEntity drink = widget.drinks[index];
            return CustomTile(drink: drink,
              //onBack: (int id){},
            );
            /*return DrinkListTile(
                        drink,
                        () {
                          widget.onBack(drink.id);
                        },
                      );*/
          },
        )
            : ListView.builder(
          itemCount: filteredDrinks.length,
          itemBuilder: (context, index) {
            DrinkEntity drink = filteredDrinks[index];
            return CustomTile(drink: drink,
              //onBack: (int id){},
            );
            /*return DrinkListTile(
                        filteredCocktails[index],
                        () {
                          widget.onBack(filteredCocktails[index].id);
                        },
                      );*/
          },
        ),
      ),
    );
  }

  void filterDrink({String filter = ''}) {
    setState(() {
      if (filter == '') return filteredDrinks.clear();
      filteredDrinks = widget.drinks
          .where((element) =>
          element.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    });
  }
}
