import 'package:cocktails/ui/components/ingredients_listing.dart';
import 'package:cocktails/entities/drink_entity.dart';
import 'package:cocktails/ui/components/favorite_button.dart';
import 'package:flutter/material.dart';

class DrinkDetail extends StatelessWidget {
  const DrinkDetail(this.entity, {super.key});

  final DrinkEntity entity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        centerTitle: true,
        actions: [FavoriteButton(entity)],
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
                              child: entity.imageUrl.isNotEmpty
                                  ? Image.network(entity.imageUrl)
                                  : const Image(
                                      image:
                                          AssetImage('assets/drink-icon.png'),
                                    ),
                            ),
                            Text(
                              entity.name,
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
                          entity.category,
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
                  IngredientsListing(entity.ingredients),
                  const Spacer(),
                  const Text(
                    'Instructions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    entity.instructions.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                ],
              )),
        ),
      ),
    );
  }
}
