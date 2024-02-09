import 'package:cocktails/models/drink_model.dart';
import 'package:cocktails/globals/api.dart';
import 'package:cocktails/globals/my_theme.dart';
import 'package:cocktails/ui/components/add_drink_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../globals/local_data.dart';
import '../components/custom_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final GlobalKey<DrinkListState> _mKey = GlobalKey();
  final Api _api= Api();
  List<DrinkModel> drinks = [];
  List<DrinkModel> filteredDrinks = [];
  List<Ingredient> ingredients = [];
  List<Ingredient> languages = [];
  final TextEditingController textController = TextEditingController();

  @override
  initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Material(
                elevation: 4,
                // Search bar
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
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
                      //filteredCocktails = _filterList(cocktails, search);
                      //fetch();
                    })
                  },
                  //controller: TextEditingController(text: search),
                ),
              ),
            ),
            /*Text('Drinks count:${cocktails.length}  '
                'Search:$search'),*/
            /*DrinkList(
              drinks: drinks,
              onBack: (int i) {},
            ),*/

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
                              },
                            ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(context),
        tooltip: 'Add Cocktail',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onBack(int id) {
    int index = filteredDrinks.indexWhere((element) => element.id == id);
    setState(() {
      drinks[index].isFavorite = getFavorite(id);
      /*textController.clear();
      _filterDrinks();*/
    });
    //print('${drinks[index].name} ${drinks[index].isFavorite}');
  }

  // Makes an API call and fill drinks list
  void fetch() async {
    // Make an API call to get all drinks
    try {

      final Response response = await _api.getAllDrinks();
      _checkResponse(response);

      drinks.clear();
      // Fill drinks list
      for (Map<String, dynamic> e in response.data) {
        if (e['name'] != null && e['name'].toString().isNotEmpty) {
          //result.add(await DrinkEntity.fromJsonApi(e));
          drinks.add(
             DrinkModel.fromJsonApi(e),
          );
        }
      }

      // Fetch properties
      final Response propertiesResponse = await _api.getAllDrinkProperties();
      _checkResponse(propertiesResponse);

      print(propertiesResponse.data);
      for (Map<String, dynamic> e in propertiesResponse.data['ingredient']) {
        ingredients.add(Ingredient.fromJson(e));
      }
      print(ingredients.toString());
    } on Exception catch (e) {
      _showError(e.toString());
      for (dynamic e in await _api.loadMockup()) {
        drinks.add(DrinkModel.fromJsonMockup(e));
      }
    }

    _filterDrinks(filter: 'a');
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

  // Filters drinks by name
  void _filterDrinks({String filter = ''}) {
    setState(() {
      if (filter.isEmpty) {
        filteredDrinks = drinks;
      } else {
        filteredDrinks = drinks
            .where((element) =>
                element.name.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      }
    });
  }

  // Opens the dialog used to add a new drink
  Future<void> _openDialog(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: MyTheme.background,
      builder: (BuildContext context) {
        return AddDrinkDialog(
            addFunction: addCocktail);
      },
    );
  }

  // Adds a new drink to the list and send a post request to API
  void addCocktail(DrinkModel cocktail) async {
    try {
      print(cocktail.toJson());
      //final Response resp = await Api.addDrink(cocktail);
      //_checkResponse(resp);
    } on Exception catch (e) {
      _showError(e.toString());
    } finally {
      setState(
        () {
          drinks.add(cocktail);
        },
      );
    }
  }
}
