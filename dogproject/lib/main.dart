import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
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
      title: 'Dog Breed Identification',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
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
  String _predOne = "";
  double _predOneConf = 0.0;
  String _predTwo = "";
  double _predTwoConf = 0.0;

  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadTfliteModel();
  }

  loadTfliteModel() async {
    String res;
    res = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    ) as String;
    print(res);
  }

  Future getImageFromGallery() async {
    print("getting image");
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    getOutputs(imageFile!);
  }

  Future getImageFromCamera() async {
    print("getting image");
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    getOutputs(imageFile!);
  }

  getOutputs(image) async {
    var recognitions = await Tflite.runModelOnImage(
        path: image!.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.0, // defaults to 0.1
        asynch: true // defaults to true
        );
    setState(() {
      _image = File(image.path);
      if (recognitions != null) {
        print(recognitions);
        _predOne = recognitions[0]['label'];
        _predOneConf = recognitions[0]['confidence'] * 100;
      } else {
        _predOne = "Could not recognize within threshold!";
      }
    });
  }

  void resetVar() {
    setState(() {
      _image = null;
      _predOne = "";
      _predOneConf = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage("images/ppbg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   title: Text("Dog Breed Identification"),
          //   elevation: 5,
          // ),
          body: Center(
            child: _image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Text("Let us determine your dog's breed!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                      ),
                      Image.asset("images/dogicon.png"),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: const Text(
                          "Select an image using the icons below!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            //backgroundColor: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 30),
                          width: 300,
                          height: 300,
                          child: Image.file(_image!),
                        ),
                        Container(
                          margin: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Text(
                                "We are ${_predOneConf.toStringAsFixed(2)}% confident that your dog is a:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _predOne.substring(2),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Row(
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
                    )
                  : Container(
                      margin: EdgeInsets.all(10),
                      child: FloatingActionButton(
                        backgroundColor: Colors.black,
                        child: Icon(Icons.replay),
                        onPressed: resetVar,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
