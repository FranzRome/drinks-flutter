import 'package:cocktails/entities/drink_entity.dart';
import 'package:flutter/material.dart';

class IngredientsListing extends StatelessWidget {
  const IngredientsListing(this.ingredients, {super.key});

  final List<Ingredient> ingredients;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            ingredients.length,
            (index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Text('${ingredients[index].name}:'),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            ingredients.length,
              (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Text(ingredients[index].measure),
                ),
          ),
        )
      ],
    );
  }
}
