import 'package:cocktails/models/drink_model.dart';
import 'package:cocktails/globals/local_data.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton(this.drink, {super.key});

  final DrinkModel drink;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite =  widget.drink.isFavorite;
    return IconButton(
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });

        widget.drink.isFavorite = isFavorite;
        setFavorite(widget.drink.id, isFavorite);
      },
      icon: Icon(isFavorite ? Icons.star : Icons.star_border),
    );
  }
}
