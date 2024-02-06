import 'package:cocktails/cocktail_detail/cocktail_detail.dart';
import 'package:cocktails/entities/cocktail_entity.dart';
import 'package:flutter/material.dart';

class CocktailListTile extends StatelessWidget {
  const CocktailListTile(this.entity, {super.key});

  final CocktailEntity entity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            entity.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            entity.category,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xAA505050)),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: entity.imageUrl.isNotEmpty
                ? Image.network(entity.imageUrl)
                : const Image(image: AssetImage('assets/drink-icon.png')),
          ),
          tileColor: Colors.white,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CocktailDetail(entity)));
          },
        ),
      ),
    );
  }
}
