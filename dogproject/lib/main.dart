import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //We need first to add 2 important plugins
  //1 - The Path Provider to get the path of files
  //2 - Image Picker which is a cool plugin that allows us to pick images from different sources

  File? _image;
  final imagePicker = ImagePicker();
  Future getImageFromGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      //assign the image path to our image File
      _image = File(image!.path);
    });
  }

  Future getImageFromCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      //assign the image path to our image File
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _image == null ? Text("No Image Selected!") : Image.file(_image!),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(Icons.add_photo_alternate_rounded),
              onPressed: getImageFromGallery,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(Icons.camera_alt_rounded),
              onPressed: getImageFromCamera,
            ),
          ),
        ],
      ),
    );
  }
}
