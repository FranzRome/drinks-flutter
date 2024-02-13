import 'dart:convert';

import 'package:cocktails/globals/local_data.dart';

class DrinkModel {
  final int id;
  final String name;
  final List<Instruction> instructions;
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

  factory DrinkModel.fromJsonApi(Map<String, dynamic> json) {
    return DrinkModel(
      id: json['id'],
      //modifyDate = DateTime.parse(json['dateModified'] ?? '2000-01-01 00:00:00'),
      name: json['name'],
      instructions: json['instructions'] is List
          ? (json['instructions'] as List)
          .map((e) => Instruction.fromJson(e))
          .toList()
          : [],
      category: json['category'],
      //isAlcoholic: json['strAlcoholic'] == 'Alcoholic' ? true : false,
      isAlcoholic: json['alcoholic'],
      ingredients: json['ingredients'] is List
          ? (json['ingredients'] as List)
          .map((e) => Ingredient.fromJson(e))
          .toList()
          : [],
      imageUrl: json['url_thumb'],
      isFavorite: getFavorite(json['id']),
    );
  }

  static DrinkModel fromJsonMock(Map<String, dynamic> json) {
    return DrinkModel(
      id: int.parse(json['idDrink']),
      //modifyDate = DateTime.parse(json['dateModified'] ?? '2000-01-01 00:00:00'),
      name: json['strDrink'],
      instructions: [
        Instruction(language: 'eng', text: json['strInstructions'])
      ],
      category: json['strCategory'],
      isAlcoholic: json['strAlcoholic'] == 'Alcoholic' ? true : false,
      ingredients: [],
      imageUrl: json['strDrinkThumb'],
      isFavorite: getFavorite(int.parse(json['idDrink'])),
    );
  }

  String toJson() =>
      jsonEncode({
        'name': name,
        'alternate_name': name,
        'alcoholic': isAlcoholic,
        'glass': 'Cocktail glass',
        'category': category,
        'url_thumb': imageUrl,
        'image_attribution': '',
        'image_source': '',
        'video': '',
        'tags': '',
        'iba': '',
        'creative_commons': '',
        'ingredients': ingredients.map((e) => e.toMap()).toList(),
        'instruction': instructions.map((e) => e.toMap()).toList(),
      }).toString();
}

class Instruction {
  final String language;
  final String text;

  Instruction({required this.language, required this.text});

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      language: json['language'],
      text: json['text'] ?? '',
    );
  }

  Map<String, String> toMap() =>
      {
        'language': language,
        'text': text,
      };

  String toJson() =>
      jsonEncode({
        'language': language,
        'text': text,
      });
}

class Ingredient {
  late String name;
  late String measure;

  Ingredient({required this.name, required this.measure});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      measure: '',
    );
  }

  Map<String, String> toMap() =>
      {
        'name': name,
        'measure': measure,
      };

  String toJson() =>
      jsonEncode({
        'name': name,
        'measure': measure,
      });
}
