import 'package:cocktails/add_cocktail/add_cocktail_dialog.dart';
import 'package:cocktails/api.dart';
import 'package:cocktails/cocktail_list/cocktail_list.dart';
import 'package:cocktails/colors.dart';
import 'package:cocktails/entities/cocktail_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: MyTheme.primary),
        scaffoldBackgroundColor: MyTheme.background,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: MyTheme.primary),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cocktails List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<CocktailListState> _mKey = GlobalKey();
  final List<CocktailEntity> drinks = [];
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Api.configureDio();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            searchBar(),
            /*Text('Drinks count:${cocktails.length}  '
                'Search:$search'),*/
            Expanded(
              child: CocktailList(drinks, key: _mKey),
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

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Material(
        elevation: 4,
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
                  _mKey.currentState?.filterCocktails(filter: textController.text);
                });
              },
            ),
          ),
          onChanged: (value) => {
            setState(() {
              _mKey.currentState?.filterCocktails(filter: textController.text);
              //filteredCocktails = _filterList(cocktails, search);
              //fetch();
            })
          },
          //controller: TextEditingController(text: search),
        ),
      ),
    );
  }

  void fetch() async {
    // Make an API call to get all drinks
    try {
      final Response response = await Api.getAllDrinks();
      _checkResponse(response);

      drinks.clear();

      // Fill drinks list
      for (Map<String, dynamic> e in response.data) {
        if (e['name'] != null && e['name'].toString().isNotEmpty) {
          drinks.add(
            CocktailEntity(
              /*id: e['id'],*/
              id: 0,
              modifyDate: e['date_modified'] != null
                  ? DateTime.parse(e['date_modified'])
                  : DateTime(2024),
              name: e['name'] ?? '',
              instructions: '',
              category: '',
              isAlcoholic: true,
              ingredients: [],
              imageUrl: e['url_thumb'] ?? '',
            ),
          );
        }
      }
    } on Exception catch (e) {
      _showError(e.toString());

      for(dynamic e in await Api.loadMockup()){
        drinks.add(CocktailEntity.fromJsonMockup(e));
      }
    }
  }

  void addCocktail(CocktailEntity cocktail) async {
    try {
      final Response resp = await Api.addDrink(cocktail);
      _checkResponse(resp);
    } on Exception catch (e) {
      _showError(e.toString());
    }

    setState(
      () {
        drinks.add(cocktail);
      },
    );
  }

  Future<void> _openDialog(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: MyTheme.background,
      builder: (BuildContext context) {
        return AddCocktailDialog(
            addFunction: addCocktail, listLength: drinks.length);
      },
    );
  }

  void _checkResponse(Response response) {
    int? code = response.statusCode;

    if (code != null) {
      if (code >= 400 && code < 500) {
        _showClientError(context);
      } else if (code >= 500 && code < 600) {
        _showServerError(context);
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
}
