import 'package:cocktails/entities/drink_entity.dart';
import 'package:cocktails/globals/my_theme.dart';
import 'package:cocktails/ui/components/favorite_button.dart';
import 'package:flutter/material.dart';

import 'drink_detail.dart';

class CustomTile extends StatefulWidget {
  final DrinkEntity drink;
  //final void Function(int id) onBack;

  const CustomTile({
    Key? key,
    required this.drink,
    //required this.onBack,
  }) : super(key: key);

  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: ListTile(
        style: ListTileStyle.drawer,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(widget.drink.imageUrl),
          /*widget.drink.imageUrl.isNotEmpty
                  ? Image.network(widget.drink.imageUrl)
                  : */

          /*const Image(
            image: AssetImage('assets/drink-icon.png'),
          ),*/
        ),
        title: Text(
          widget.drink.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.drink.category,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: MyTheme.lightText,
          ),
        ),
        trailing: FavoriteButton(widget.drink),
        onTap: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => DrinkDetail(widget.drink),
            ),
          )
              .then(
            (_) {
              print(widget.drink.hashCode);
              setState(() {

              });
              //onBack(drink.id);
            },
          );
        },
      ),
    );
  }
}
