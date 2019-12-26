
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

  @override
void initState() {
  super.initState();
  
  availableCameras().then((availableCameras) {
    
    cameras = availableCameras;
    if (cameras.length > 0) {
      setState(() {
        
        selectedCameraIdx = 0;
      });

      _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
    }else{
      print("No camera available");
    }
  }).catchError((err) {
   
    print('Error: $err.code\nError Message: $err.message');
  });
}

Future _initCameraController(CameraDescription cameraDescription) async {
  if (controller != null) {
    await controller.dispose();
  }

  
  controller = CameraController(cameraDescription, ResolutionPreset.high);

  
  controller.addListener(() {
   
    if (mounted) {
      setState(() {});
    }

    if (controller.value.hasError) {
      print('Camera error ${controller.value.errorDescription}');
    }
  });

  // 6
  try {
    await controller.initialize();
  } on CameraException catch (e) {
    _showCameraException(e);
  }

  if (mounted) {
    setState(() {});
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Click To Share'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _cameraTogglesRowWidget(),
                  _captureControlRowWidget(context),
                  Spacer()
                ],
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _cameraPreviewWidget() {
    
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
  }

  

  
  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: Icon(Icons.camera),
                backgroundColor: Colors.blueGrey,
                onPressed: () {
                  _onCapturePressed(context);
                })
          ],
        ),
      ),
    );
  }

  
  Widget _cameraTogglesRowWidget() {
    
    return Spacer();
  }

  void _onCapturePressed(context) async {
    
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }
}