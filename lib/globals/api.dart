import 'dart:convert';

import 'package:cocktails/entities/drink_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class Api {
  static late Dio _dio;

  // Call this method in main to configure dio
  static void configureDio() {
    final connectionOptions = BaseOptions(
      baseUrl: 'http://192.168.178.36:8080/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );

    _dio = Dio(connectionOptions);
  }

  static Future<Response> getAllDrinks() async {
    return await _dio.get('api/drink/getall');
  }

  static Future<Response> addDrink(DrinkEntity cocktail) async {
    return await _dio.post('api/drink', data: cocktail.toJson());
  }

  static Future<List<dynamic>> loadMockup() async {
    List<dynamic> result = json.decode(
        await rootBundle.loadString('assets/json/drinks.json'))['drinks'];

    return result;
  }
}
