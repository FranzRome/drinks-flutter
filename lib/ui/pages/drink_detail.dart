import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/models/drink_model.dart';
import 'package:cocktails/ui/components/favorite_button.dart';
import 'package:flutter/material.dart';

class DrinkDetail extends StatelessWidget {
  const DrinkDetail(this.drink, {super.key});

  final DrinkModel drink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        centerTitle: true,
        actions: [FavoriteButton(drink)],
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: const BoxDecoration(color: Color(0xFFC5C5C5)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: drink.imageUrl,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => const Image(
                                  image: AssetImage('assets/drink-icon.png'),
                                ),
                              ),
                            ),
                            Text(
                              drink.name,
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: Row(
                      children: [
                        const Text(
                          'Category:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          drink.category,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IngredientsListing(drink.ingredients),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    'Instructions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  drink.instructions.isNotEmpty
                      ? Text(
                          drink.instructions[0].text,
                          style: const TextStyle(fontSize: 16),
                        )
                      : const Text('Instructions missing'),
                  const Spacer(),
                ],
              )),
        ),
      ),
    );
  }
}

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
          children: ingredients.isNotEmpty
              ? List.generate(
                  ingredients.length,
                  (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: Text('${ingredients[index].name}:'),
                      ),
                    ],
                  ),
                )
              : [const Text('Ingredients missing')],
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
