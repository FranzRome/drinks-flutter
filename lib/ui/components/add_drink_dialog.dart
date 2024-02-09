import 'package:cocktails/models/drink_model.dart';
import 'package:flutter/material.dart';

//TODO Try Bottom Sheet

class AddDrinkDialog extends StatefulWidget {
  final AddFunction addFunction;
  final int listLength;

  const AddDrinkDialog({
    super.key,
    required this.addFunction,
    required this.listLength,
  });

  @override
  State<AddDrinkDialog> createState() => _AddDrinkDialogState();
}

class _AddDrinkDialogState extends State<AddDrinkDialog> {
  String name = '';
  String category = '';
  bool isAlcoholic = true;
  List<Instruction> instructions = [Instruction('', '')];
  List<Ingredient> ingredients = [Ingredient('', '')];
  String imageUrl = '';

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
                TextField(
                  obscureText: false,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  onChanged: (value) => {category = value},
                ),
                const SizedBox(height: 18),
                TextField(
                  maxLines: 3,
                  obscureText: false,
                  decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      labelText: 'Instructions',
                      labelStyle: TextStyle()),
                  onChanged: (value) => {instructions[0].text = value},
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
                TextButton(
                  onPressed: () {
                    setState(() {
                      ingredients.add(
                        Ingredient('', ''),
                      );
                    });
                  },
                  child: const Text('Add Ingredient'),
                ),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${index + 1}.',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingredient',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                  controller:
                      TextEditingController(text: ingredients[index].name),
                  onChanged: (value) {
                    ingredients[index].name = value;
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Measure',
                      labelStyle: TextStyle(fontSize: 12)),
                  controller:
                      TextEditingController(text: ingredients[index].measure),
                  onChanged: (value) {
                    ingredients[index].measure = value;
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
    if (name.isEmpty || instructions.isEmpty || category.isEmpty) {
      _showError(context);
      return;
    }

    for (Ingredient i in ingredients) {
      if (i.name.isEmpty || i.measure.isEmpty) {
        _showError(context);
        return;
      }
    }

    widget.addFunction(
      DrinkModel(
        id: widget.listLength + 1,
        //modifyDate: DateTime.now(),
        name: name,
        instructions: instructions[0],
        category: category,
        isAlcoholic: isAlcoholic,
        ingredients: ingredients,
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
