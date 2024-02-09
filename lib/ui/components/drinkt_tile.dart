import 'package:cocktails/ui/pages/drink_detail.dart';
import 'package:cocktails/models/drink_model.dart';
import 'package:cocktails/ui/components/favorite_button.dart';
import 'package:flutter/material.dart';

class DrinkTile extends StatefulWidget {
  const DrinkTile({super.key, required this.drink, required this.backFun});

  final DrinkModel drink;
  final Function backFun;

  @override
  State<DrinkTile> createState() => _DrinkTileState();
}

class _DrinkTileState extends State<DrinkTile> {
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
            widget.drink.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.drink.category,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xAA505050)),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: /*widget.drink.imageUrl.isNotEmpty
                ? Image.network(widget.drink.imageUrl)
                : */
            Image.network(widget.drink.imageUrl),
          ),
          trailing: FavoriteButton(widget.drink),
          tileColor: Colors.white,
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => DrinkDetail(widget.drink)))
                .then((value) => widget.backFun());
          },
        ),
      ),
    );
  }
}
