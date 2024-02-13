import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cocktails/globals/my_theme.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late final CameraController _controller;
  late final Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    //return Container();
    /*
    You must wait until the controller is initialized before displaying the
    camera preview. Use a FutureBuilder to display a loading spinner until the
    controller has finished initializing.
    */
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
            return SafeArea(
              child: CameraPreview(
                _controller,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () async {
                              try {
                                await _initializeControllerFuture;
                                final image =
                                    await _controller.takePicture();
                                if (!mounted) return;

                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DisplayPictureScreen(
                                      // Pass the automatically generated path to
                                      // the DisplayPictureScreen widget.
                                      imagePath: image.path,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: const Icon(Icons.camera_alt),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display the Picture'),
      ),
      backgroundColor: MyTheme.lightText,
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8, left: 8, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.file(
                File(imagePath),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Confirm'))
          ],
        ),
      ),
    );
  }
}
