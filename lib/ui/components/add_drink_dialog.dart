import 'package:cocktails/models/drink_model.dart';
import 'package:flutter/material.dart';

class AddDrinkDialog extends StatefulWidget {
  final AddFunction addFunction;
  final List<Ingredient> availableIngredients;
  final List<String> availableCategories;

  const AddDrinkDialog({
    super.key,
    required this.addFunction,
    required this.availableIngredients,
    required this.availableCategories,
  });

  @override
  State<AddDrinkDialog> createState() => _AddDrinkDialogState();
}

class _AddDrinkDialogState extends State<AddDrinkDialog> {
  String name = '';
  late String selectedCategory;
  bool isAlcoholic = true;
  List<Instruction> instructions = [Instruction(language: 'eng', text: '')];
  List<Ingredient> ingredients = [Ingredient(name: '', measure: '')];
  late String selectedIngredientName;
  String imageUrl = '';

  TextEditingController instructionsTextController = TextEditingController();
  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController ingredientMeasureController = TextEditingController();

  @override
  void initState() {
    selectedCategory = widget.availableCategories.first;
    selectedIngredientName = widget.availableIngredients.first.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom), // Prevent keyboard to go over the widget
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: Column(
              children: [
                const SizedBox(height: 18),
                TextField(
                  obscureText: false,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  onChanged: (value) => {name = value},
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: DropdownMenu<String>(
                    initialSelection: widget.availableCategories.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    dropdownMenuEntries: widget.availableCategories.map<DropdownMenuEntry<String>>((String c) {
                      return DropdownMenuEntry<String>(value: c, label: c);
                    }).toList(),
                  ),
                ),
                /*TextField(
                  obscureText: false,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  onChanged: (value) => {category = value},
                ),*/
                const SizedBox(height: 18),
                TextField(
                  controller: instructionsTextController,
                  maxLines: 3,
                  obscureText: false,
                  decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      labelText: 'Instructions',
                      labelStyle: TextStyle()),
                  onChanged: (value) => {},
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 180),
                  child: CheckboxListTile(
                      value: isAlcoholic,
                      title: const Text(
                        'Alcoholic',
                      ),
                      onChanged: (bool? value) => {
                            setState(() {
                              isAlcoholic = !isAlcoholic;
                            })
                          }),
                ),
                ingredientsInputs(),
                /*TextButton(
                  onPressed: () {
                    setState(() {
                      ingredients.add(
                        Ingredient('', ''),
                      );
                    });
                  },
                  child: const Text('Add Ingredient'),
                ),*/
                const SizedBox(height: 18),
                TextField(
                  obscureText: false,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelText: 'Image URL',
                  ),
                  onChanged: (value) => {imageUrl = value},
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    submit();
                  },
                  child: const Text('Confirm'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ingredientsInputs() {
    return Column(
      children: List.generate(
        ingredients.length,
        (index) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${index + 1}.',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 5),
              DropdownMenu<String>(
                initialSelection: selectedIngredientName,
                width: 180,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    selectedIngredientName = value!;
                  });
                },
                dropdownMenuEntries: widget.availableIngredients.map<DropdownMenuEntry<String>>((Ingredient i) {
                  return DropdownMenuEntry<String>(value: i.name, label: i.name);
                }).toList(),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 80,
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Measure',
                      //labelStyle: TextStyle(fontSize: 12),
                  ),
                  controller: ingredientMeasureController,
                  onChanged: (value) {
                    //ingredients[index].measure = value;
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 24,
                  color: ingredients.length > 1
                      ? const Color(0xFFCC0000)
                      : const Color(0xFFA0A0A0),
                ),
                onPressed: ingredients.length > 1
                    ? () {
                        setState(() {
                          ingredients.removeAt(index);
                        });
                      }
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (name.isEmpty ||
        instructionsTextController.text.isEmpty) {
      _showError(context);
      return;
    }

    /*for (Ingredient i in ingredients) {
      if (i.name.isEmpty || i.measure.isEmpty) {
        _showError(context);
        return;
      }
    }*/

    if (ingredientMeasureController.text.isEmpty) {
      _showError(context);
      return;
    }

    widget.addFunction(
      DrinkModel(
        id: -1,
        //modifyDate: DateTime.now(),
        name: name,
        instructions: [
          Instruction(
            language: 'eng',
            text: instructionsTextController.text,
          )
        ],
        category: selectedCategory,
        isAlcoholic: isAlcoholic,
        ingredients: [
          Ingredient(
            name: selectedIngredientName,
            measure: ingredientMeasureController.text,
          )
        ],
        imageUrl: imageUrl,
        isFavorite: true,
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _showError(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'You forgot to fill some field!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }
}

typedef AddFunction = void Function(DrinkModel cocktail);
