import 'package:camera/camera.dart';
import 'package:cocktails/globals/api.dart';
import 'package:cocktails/globals/my_theme.dart';
import 'package:cocktails/models/drink_model.dart';
import 'package:cocktails/ui/components/add_drink_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import '../../globals/local_data.dart';
import '../components/custom_tile.dart';

class HomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera;
  final List<DrinkModel> drinks;
  final List<String> categories;
  final List<Ingredient> ingredients;

  const HomePage({
    super.key,
    required this.title,
    required this.camera,
    required this.drinks,
    required this.categories,
    required this.ingredients,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final GlobalKey<DrinkListState> _mKey = GlobalKey();
  final Api _api = Api();
  List<DrinkModel> filteredDrinks = [];
  final TextEditingController textController = TextEditingController();
  final PageController controller = PageController();

  @override
  initState() {
    _initFirebase();
    setState(() {
      _filterDrinks(filter: 'a');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              12,
              12,
              0,
            ),
            child: Material(
              elevation: 4,
              // Search bar
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  fillColor: MyTheme.background,
                  labelText: 'Search',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      setState(() {
                        textController.clear();
                        _filterDrinks(filter: textController.text);
                      });
                    },
                  ),
                ),
                onChanged: (value) => {
                  setState(() {
                    _filterDrinks(filter: textController.text);
                    //fetch();
                  })
                },
                //controller: TextEditingController(text: search),
              ),
            ),
          ),
          // Drinks list
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  child: /*widget.drinks.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 38),
                        child: Text(
                          'The list is empty\nPress the button to add a new drink',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  :*/
                      Column(
                    children: filteredDrinks
                        .map(
                          (drink) => CustomTile(
                              drink: drink,
                              onBack: (id) {
                                onBack(drink.id);
                              }),
                        )
                        .toList(),
                  )
                  //   ListView.builder(
                  // itemCount: filteredDrinks.length,
                  // itemBuilder: (context, index) {
                  //   DrinkEntity drink = filteredDrinks[index];
                  //   return CustomTile(
                  //       drink: drink,
                  //       onBack: (id) {
                  //         onBack(drink.id);
                  //       });
                  //}
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddDialog(context),
        tooltip: 'Add Cocktail',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function called on returning back from detail page
  void onBack(int id) {
    int index = filteredDrinks.indexWhere((element) => element.id == id);
    setState(() {
      widget.drinks[index].isFavorite = getFavorite(id);
      /*textController.clear();
      _filterDrinks();*/
    });
    //print('${drinks[index].name} ${drinks[index].isFavorite}');
  }

  void _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Makes an API call and fill drinks list
  /*void _fetch() async {
    // Make an API call to get all drinks
    try {
      final Response response = await _api.getAllDrinks();
      _checkResponse(response);

      widget.drinks.clear();
      // Fill drinks list
      for (Map<String, dynamic> e in response.data) {
        if (e['name'] != null && e['name'].toString().isNotEmpty) {
          //result.add(await DrinkEntity.fromJsonApi(e));
          widget.drinks.add(
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

      _filterDrinks(filter: 'a');

      // Build UI after fetching data
      setState(() {});
    } on Exception catch (e) {
      _showError(e.toString());
      //print('Loading mock');

      for (dynamic e in await _api.loadDrinkMock()) {
        widget.drinks.add(DrinkModel.fromJsonMock(e));
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

    _filterDrinks(filter: 'a');
    // Build UI after fetching data
    setState(() {});
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
  }*/

  // Filters drinks by name
  void _filterDrinks({String filter = ''}) {
    if (filter.trim().isEmpty) {
      filteredDrinks = widget.drinks;
    } else {
      filteredDrinks = widget.drinks
          .where((element) =>
              element.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
  }

  // Opens the dialog used to add a new drink
  Future<void> _openAddDialog(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: MyTheme.primaryLight,
      builder: (BuildContext context) {
        return AddDrinkDialog(
          addFunction: addDrink,
          availableIngredients: widget.ingredients,
          availableCategories: widget.categories,
          camera: widget.camera,
        );
      },
    );
  }

  // Adds a new drink to the list and send a post request to API
  void addDrink(DrinkModel drink) async {
    try {
      //print(drink.toJson());
      final Response resp = await _api.addDrink(drink);
      //_checkResponse(resp);
    } on Exception catch (e) {
      //_showError(e.toString());
    } finally {
      setState(
        () {
          widget.drinks.add(drink);
        },
      );
    }
  }
}
