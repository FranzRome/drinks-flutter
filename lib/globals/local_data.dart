import 'package:hive_flutter/hive_flutter.dart';

bool getFavorite(int id) {
  return Hive.box('favorites').get(id) ?? false;
}

void setFavorite(int id, bool value) async {
  Hive.box('favorites').put(id, value);
}