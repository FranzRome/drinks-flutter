import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/globals/my_theme.dart';
import 'package:cocktails/models/drink_model.dart';
import 'package:cocktails/ui/components/favorite_button.dart';
import 'package:flutter/material.dart';

import '../pages/drink_detail.dart';

class CustomTile extends StatelessWidget {
  final DrinkModel drink;
  final void Function(int id) onBack;

  const CustomTile({
    super.key,
    required this.drink,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: ListTile(
        style: ListTileStyle.drawer,
        leading: ClipRRect(
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
        title: Text(
          drink.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          drink.category,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: MyTheme.lightText,
          ),
        ),
        trailing: FavoriteButton(drink),
        onTap: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => DrinkDetail(drink),
            ),
          )
              .then(
            (_) {
              onBack(drink.id);
            },
          );
        },
      ),
    );
  }
}
