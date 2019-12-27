import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    
    return _MyAppState();
  }

  
}

class _MyAppState extends State<MyApp> {

  File _image;
Future getImage(bool isCamera) async {
  File image;
  if(isCamera) {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
  } else {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  setState(() {
    _image = image;
  });
}
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Camera App'),
        ),
        body: Center(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.insert_drive_file),
              onPressed: () {
                getImage(false);
              },
            ),
            SizedBox(
              height: 10.0,
              ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                getImage(true);
              },
            ),
            _image == null? Container() 
            : Image.file(_image, height: 300.0,width: 300.0,),

          ],
            
          ),
        ),
      ),
    );
  }

  
}