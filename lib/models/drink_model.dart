import 'dart:convert';

import 'package:cocktails/globals/local_data.dart';

class DrinkModel {
  final int id;
  final String name;
  final Instruction instructions;
  final String category;
  final bool isAlcoholic;
  final List<Ingredient> ingredients;
  final String imageUrl;
  bool isFavorite;

  DrinkModel({
    required this.id,
    required this.name,
    required this.instructions,
    required this.category,
    required this.isAlcoholic,
    required this.ingredients,
    required this.imageUrl,
    required this.isFavorite,
  });

  static DrinkModel fromJsonApi(Map<String, dynamic> json) {
    return DrinkModel(
      id: json['id'],
      //modifyDate = DateTime.parse(json['dateModified'] ?? '2000-01-01 00:00:00'),
      name: json['name'],
      instructions: json['instructions'],
      category: json['category'],
      //isAlcoholic: json['strAlcoholic'] == 'Alcoholic' ? true : false,
      isAlcoholic: json['alcoholic'],
      ingredients: json['ingredients'],
      imageUrl: json['url_thumb'],
      isFavorite: getFavorite(json['id']),
    );
  }

  static DrinkModel fromJsonMockup(Map<String, dynamic> json) {
    return DrinkModel(
      id: int.parse(json['idDrink']),
      //modifyDate = DateTime.parse(json['dateModified'] ?? '2000-01-01 00:00:00'),
      name: json['strDrink'],
      instructions: json['strInstructions'],
      category: json['strCategory'],
      isAlcoholic: json['strAlcoholic'] == 'Alcoholic' ? true : false,
      ingredients: [],
      imageUrl: json['strDrinkThumb'],
      isFavorite: getFavorite(int.parse(json['idDrink'])),
    );
  }

  String toJson() => jsonEncode(
        {
          'name': name,
          'alternate_name': name,
          'alcoholic': isAlcoholic,
          'glass': '',
          'category': '',
          'url_thumb': imageUrl,
          'image_attribution': '',
          'image_source': '',
          'video': '',
          'tags': '',
          'iba': '',
          'creative_commons': '',
          'ingredients': jsonEncode(ingredients),
          'strInstructions': jsonEncode(instructions),
        },
      );
}

class Instruction {
  late final String language;
  late final String text;

  Instruction(this.language, this.text);

  Instruction.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    text = json['text'];
  }

/*Map<String, dynamic> toJson() => {
        'language': text,
        'text': language,
      };*/
}

class Ingredient {
  late final String name;
  late final String measure;

  Ingredient(this.name, this.measure);

  Ingredient.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    measure = json['measure'];
  }
/*String toJson() => {
        'name': name,
        'measure': measure,
      };*/
}
