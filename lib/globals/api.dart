import 'dart:convert';

import 'package:cocktails/models/drink_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class Api {
  late Dio _dio;

  Api() {
    final connectionOptions = BaseOptions(
      baseUrl: 'http://192.168.178.36:8080/',
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
    );

    _dio = Dio(connectionOptions);
  }

  Future<Response> getAllDrinks() async {
    return await _dio.get('api/drink/getall');
  }

  Future<Response> getAllDrinkProperties() async {
    return await _dio.get('category-glass-ingredient-language');
  }

  Future<Response> addDrink(DrinkModel cocktail) async {
    Response resp = await _dio.post('api/drink', data: cocktail.toJson());
    return resp;
  }

  Future<List<dynamic>> loadDrinkMock() async {
    List<dynamic> result = json.decode(
        await rootBundle.loadString('assets/json/drinks.json'))['drinks'];

    return result;
  }

  Future<Map<String, dynamic>> loadDrinkPropertiesMock() async {
    Map<String, dynamic> result = json.decode(
        await rootBundle.loadString('assets/json/properties.json'));

    return result;
  }
}
