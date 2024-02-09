import 'dart:convert';

import 'package:cocktails/globals/local_data.dart';

class DrinkModel {
  final int id;

  //final DateTime modifyDate;
  final String name;
  final String instructions;
  final String category;
  final bool isAlcoholic;
  final List<Ingredient> ingredients;
  final String imageUrl;
  bool isFavorite;

  DrinkModel({
    required this.id,
    //required this.modifyDate,
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
      instructions: '',
      category: json['category'],
      //isAlcoholic: json['strAlcoholic'] == 'Alcoholic' ? true : false,
      isAlcoholic: true,
      ingredients: [],
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'idDrink': '',
        'strDrink': name,
        'strInstructions': instructions,
        'strCategory': category,
        'strAlcoholic': isAlcoholic ? 'Alcoholic' : 'Not Alcoholic',
        'ingredients': jsonEncode(ingredients),
        'strDrinkThumb': imageUrl,
      };
}

class Instruction {
  String language;
  String text;

  Instruction(this.language, this.text);

  Map<String, dynamic> toJson() => {
        'language': text,
        'text': language,
      };
}

class Ingredient {
  String name;
  String measure;

  Ingredient(this.name, this.measure);

  Map<String, dynamic> toJson() => {
        'name': name,
        'measure': measure,
      };
}
