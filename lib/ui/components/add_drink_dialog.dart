import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cocktails/models/drink_model.dart';
import 'package:cocktails/ui/pages/take_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDrinkDialog extends StatefulWidget {
  final AddFunction addFunction;
  final List<Ingredient> availableIngredients;
  final List<String> availableCategories;
  final CameraDescription camera;

  const AddDrinkDialog({
    super.key,
    required this.addFunction,
    required this.availableIngredients,
    required this.availableCategories,
    required this.camera,
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
  late XFile? _image = XFile('');

  //late List<String> ingredientsName;
  String imageUrl = '';

  TextEditingController instructionsTextController = TextEditingController();

  //List<TextEditingController> ingredientNameControllers = [TextEditingController()];
  List<TextEditingController> ingredientMeasureControllers = [
    TextEditingController()
  ];

  @override
  void initState() {
    selectedCategory = widget.availableCategories.first;
    ingredients[0].name = widget.availableIngredients[0].name;
    //ingredientsName = [widget.availableIngredients[0].name];
    //selectedIngredientName = widget.availableIngredients.first.name;
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: DropdownMenu<String>(
                    hintText: 'Category',
                    initialSelection: widget.availableCategories.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    dropdownMenuEntries: widget.availableCategories
                        .map<DropdownMenuEntry<String>>((String c) {
                      return DropdownMenuEntry<String>(value: c, label: c);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 32),
                const Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                ingredientsInputs(),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        ingredients.add(
                          Ingredient(
                              name: widget.availableIngredients[0].name,
                              measure: ''),
                        );
                        ingredientMeasureControllers
                            .add(TextEditingController());
                      });
                    },
                    child: const Text('Add Ingredient'),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Alcoholic',
                      style: TextStyle(fontSize: 16),
                    ),
                    Checkbox(
                      value: isAlcoholic,
                      onChanged: (bool? value) => {
                        setState(
                          () {
                            isAlcoholic = !isAlcoholic;
                          },
                        )
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Image:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                //const SizedBox(height: 12),
                _image!.path.isNotEmpty
                    ?
                  ClipPath(
                    clipper: SquareClip(),
                    child: Image.file(
                      File(_image!.path),
                    ),
                  )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                TakePictureScreen(camera: widget.camera),
                          ),
                        );
                      },
                      child: const Text(
                          'Take a picture'), /*const Icon(Icons.camera_alt),*/
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () {
                        openGallery();
                      },
                      child: const Text(
                          'Open gallery'), /*const Icon(Icons.camera_alt),*/
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        submit();
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
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
                hintText: 'Name',
                initialSelection: ingredients[index].name,
                width: 180,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    //ingredientsName[index] = value!;
                    ingredients[index].name = value!;
                  });
                },
                dropdownMenuEntries: widget.availableIngredients
                    .map<DropdownMenuEntry<String>>((Ingredient i) {
                  return DropdownMenuEntry<String>(
                      value: i.name, label: i.name);
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
                  controller: ingredientMeasureControllers[index],
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
                          ingredientMeasureControllers.removeAt(index);
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

  void openGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void submit() {
    if (name.isEmpty || instructionsTextController.text.isEmpty) {
      _showError(context);
      return;
    }

    /*for (Ingredient i in ingredients) {
      if (i.name.isEmpty || i.measure.isEmpty) {
        _showError(context);
        return;
      }
    }*/

    for (TextEditingController tec in ingredientMeasureControllers) {
      if (tec.text.isEmpty) {
        _showError(context);
        return;
      }
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

class SquareClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.addRect(const Offset(0, 150) & const Size(360, 360));
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

typedef AddFunction = void Function(DrinkModel cocktail);
