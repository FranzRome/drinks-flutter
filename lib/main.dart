import 'package:camera/camera.dart';
import 'package:cocktails/globals/my_theme.dart';
import 'package:cocktails/ui/pages/favorites.dart';
import 'package:cocktails/ui/pages/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'globals/api.dart';
import 'models/drink_model.dart';

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

class MyApp extends StatefulWidget {
  final CameraDescription camera;

  const MyApp({
    super.key,
    required this.camera,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String title = 'Drinks';
  final Api _api = Api();
  final PageController controller = PageController();
  final List<DrinkModel> drinks = [];
  final List<String> categories = [];
  final List<Ingredient> ingredients = [];
  final List<String> glasses = [];
  final List<String> languages = [];

  //int _selectedIndex = 0;

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      //Force device orientation to portrait
      DeviceOrientation.portraitUp,
    ]);
    /*return MaterialApp(
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
    );*/
    return MaterialApp(
      title: 'Drinks',
      theme: ThemeData(
        // Theme settings
        appBarTheme: const AppBarTheme(color: MyTheme.primary),
        scaffoldBackgroundColor: MyTheme.background,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: MyTheme.primary),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          onTap: (int index) {
            _onItemTapped(index);
          },
        ),
        /*bottomNavigationBar: BottomBarBubble(
          items: [
            BottomBarItem(
              iconData: Icons.home,
              label: 'Home',
            ),
            BottomBarItem(
              iconData: Icons.star,
              label: 'Favorites',
            ),
            BottomBarItem(
              iconData: Icons.settings,
              label: 'Setting',
            ),
          ],
          onSelect: (int index) {_onItemTapped(index);},
        ),*/
        body: PageView(
          controller: controller,
          children: <Widget>[
            HomePage(title: 'Drink List',
              camera: widget.camera,
              drinks: drinks,
              categories: categories,
              ingredients: ingredients,),
            Favorites(drinks: drinks),
            const Center(
              child: Text('Third Page'),
            ),
          ],
        ),
      ),
    );
  }

  void _fetch() async {
    // Make an API call to get all drinks
    try {
      final Response response = await _api.getAllDrinks();
      _checkResponse(response);

      drinks.clear();
      // Fill drinks list
      for (Map<String, dynamic> e in response.data) {
        if (e['name'] != null && e['name']
            .toString()
            .isNotEmpty) {
          //result.add(await DrinkEntity.fromJsonApi(e));
          drinks.add(
            DrinkModel.fromJsonApi(e),
          );
        }
      }

      // Fetch properties
      final Response propertiesResponse = await _api.getAllDrinkProperties();
      _checkResponse(propertiesResponse);

      //print(propertiesResponse.data);
      // Fill ingredients list
      for (Map<String, dynamic> e in propertiesResponse.data['ingredient']) {
        ingredients.add(Ingredient.fromJson(e));
      }

      for (Map<String, dynamic> e in propertiesResponse.data['category']) {
        categories.add(e['name']);
      }

      for (Map<String, dynamic> e in propertiesResponse.data['glass']!) {
        glasses.add(e['name']);
      }

      for (Map<String, dynamic> e in propertiesResponse.data['languages']!) {
        languages.add(e['language']);
      }

      /*_filterDrinks(filter: 'a');

      // Build UI after fetching data
      setState(() {});*/
    } on Exception catch (e) {
      _showError(e.toString());
      //print('Loading mock');

      for (dynamic e in await _api.loadDrinkMock()) {
        drinks.add(DrinkModel.fromJsonMock(e));
      }

      Map<String, dynamic> drinkProps = await _api.loadDrinkPropertiesMock();

      for (Map<String, dynamic> e in drinkProps['ingredient']!) {
        ingredients.add(Ingredient.fromJson(e));
      }

      for (Map<String, dynamic> e in drinkProps['category']!) {
        categories.add(e['name']);
      }

      for (Map<String, dynamic> e in drinkProps['glass']!) {
        glasses.add(e['name']);
      }

      for (Map<String, dynamic> e in drinkProps['languages']!) {
        languages.add(e['language']);
      }
    }

    /*_filterDrinks(filter: 'a');
    // Build UI after fetching data
    setState(() {});*/
  }

  // Checks a response status code and eventually shows an error
  void _checkResponse(Response response) {
    int? code = response.statusCode;

    if (code != null) {
      if (code >= 400 && code < 500) {
        _showClientError(context);
      } else if (code >= 500 && code < 600) {
        _showServerError(context);
      } else if (code == 204) {
        var message = 'No content from server';
        _showError(message);
        throw Exception(message);
      }
    }
  }

  // Shows a dialog containing the error message
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            AlertDialog(
              content: Column(
                children: [
                  const Text('Error'),
                  Text(message),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _showClientError(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('There was a client error!'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showServerError(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('There was a client error!'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      //_selectedIndex = index;
    });
  }
}
