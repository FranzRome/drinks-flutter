import 'dart:convert';

import 'package:cocktails/globals/local_data.dart';

class DrinkEntity {
  final int id;

  //final DateTime modifyDate;
  final String name;
  final String instructions;
  final String category;
  final bool isAlcoholic;
  final List<Ingredient> ingredients;
  final String imageUrl;
  bool isFavorite;

  DrinkEntity({
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

  static Future<DrinkEntity> fromJsonApi(Map<String, dynamic> json) async {
    return DrinkEntity(
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

  static Future<DrinkEntity> fromJsonMockup(Map<String, dynamic> json) async {
    return DrinkEntity(
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
        /*'strIngredient2': ingredients[1].name,
        'strIngredient3': ingredients[2].name,
        'strIngredient4': ingredients[3].name,
        'strIngredient5': ingredients[4].name,
        'strIngredient6': ingredients[5].name,
        'strIngredient7': ingredients[6].name,
        'strIngredient8': ingredients[7].name,
        'strIngredient9': ingredients[8].name,
        'strIngredient10': ingredients[9].name,
        'strIngredient11': ingredients[10].name,
        'strIngredient12': ingredients[11].name,
        'strIngredient13': ingredients[12].name,
        'strIngredient14': ingredients[13].name,
        'strIngredient15': ingredients[14].name,
        'strMeasure1': ingredients[0].measure,
        'strMeasure2': ingredients[1].measure,
        'strMeasure3': ingredients[2].measure,
        'strMeasure4': ingredients[3].measure,
        'strMeasure5': ingredients[4].measure,
        'strMeasure6': ingredients[5].measure,
        'strMeasure7': ingredients[6].measure,
        'strMeasure8': ingredients[7].measure,
        'strMeasure9': ingredients[8].measure,
        'strMeasure10': ingredients[9].measure,
        'strMeasure11': ingredients[10].measure,
        'strMeasure12': ingredients[11].measure,
        'strMeasure13': ingredients[12].measure,
        'strMeasure14': ingredients[13].measure,
        'strMeasure15': ingredients[14].measure,*/
        'strDrinkThumb': imageUrl,
        /*'dateModified': modifyDate.toString(),*/
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
