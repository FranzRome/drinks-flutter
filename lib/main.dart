import 'package:camera/camera.dart';
import 'package:cocktails/globals/my_theme.dart';
import 'package:cocktails/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('favorites');

  WidgetsFlutterBinding.ensureInitialized();
  // Camera init
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    MyApp(
      camera: firstCamera,
    ),
  );
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({
    super.key,
    required this.camera,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      //Force device orientation to portrait
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Drinks',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: MyTheme.primary),
        scaffoldBackgroundColor: MyTheme.background,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: MyTheme.primary),
        useMaterial3: true,
      ),
      home: HomePage(
        title: 'Cocktails List',
        camera: camera,
      ),
    );
  }
}
