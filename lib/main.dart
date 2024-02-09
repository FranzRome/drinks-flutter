import 'package:cocktails/globals/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cocktails/ui/pages/home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: MyTheme.primary),
        scaffoldBackgroundColor: MyTheme.background,
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: MyTheme.primary),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Cocktails List'),
    );
  }
}
