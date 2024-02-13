import 'package:hive_flutter/hive_flutter.dart';

import '../models/drink_model.dart';

bool getFavorite(int id) {
  return Hive.box('favorites').get(id) ?? false;
}

List<DrinkModel> getFavorites(List<DrinkModel> drinks) {
  List<DrinkModel> result = [];

  for (DrinkModel d in drinks) {
    if (Hive.box('favorites').get(d.id) == true) result.add(d);
  }

  return result;
}

void setFavorite(int id, bool value) async {
  Hive.box('favorites').put(id, value);
}
