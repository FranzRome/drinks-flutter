import 'package:cocktails/entities/cocktail_entity.dart';
import 'package:cocktails/cocktail_detail/ingredients_listing.dart';
import 'package:flutter/material.dart';

class CocktailDetail extends StatelessWidget {
  const CocktailDetail(this.entity, {super.key});

  final CocktailEntity entity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
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
                                child: Image.network(entity.imageUrl)),
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
