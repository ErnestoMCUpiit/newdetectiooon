import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LiveCamera extends StatefulWidget {
  final CameraDescription camera;

  const LiveCamera({
    super.key,
    required this.camera,
  });

  @override
  _LiveCameraState createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera>
with WidgetsBindingObserver {
  late CameraController cameraController;
  bool _isProcessing = false;
  // late ImageClassificationHelper imageClassificationHelper;
  Map<String, double>? classification;
  

  initCamera() {
    cameraController = CameraController(widget.camera, ResolutionPreset.medium,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420);
    cameraController.initialize().then((value) {
      cameraController.startImageStream(imageAnalysis);
      // cameraController.startImageStream((image) => _cameraImage = image);
      
      if (mounted) {
        setState(() {});
      }
    });
  }

   Future<void> imageAnalysis(CameraImage cameraImage) async {
    // if image is still analyze, skip this frame
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    // classification =
    //     await imageClassificationHelper.inferenceCameraFrame(cameraImage);
    print('Cámara inicializada y tomando imágenes correctamente.');
    _isProcessing = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    print('Cámara inicializada y tomando imágenes correctamente.');
    // imageClassificationHelper = ImageClassificationHelper();
    // imageClassificationHelper.initHelper();
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController.value.isStreamingImages) {
          await cameraController.startImageStream(imageAnalysis);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    // imageClassificationHelper.close();
    super.dispose();
  }
  
  Widget cameraWidget(context) {
    var camera = cameraController.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    list.add(
      SizedBox(
        child: (!cameraController.value.isInitialized)
            ? Container()
            : cameraWidget(context),
      ),
    );
    list.add(
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: const Color.fromARGB(255, 20, 44, 92),
          height: 200,
          width: MediaQuery.of(context).size.width,

          child: Padding(padding: EdgeInsets.fromLTRB(20, 70, 0, 20), 
            child: const Text("Predicciones:",
              style: TextStyle(
                  fontFamily: "quicksand",
                  color: Color.fromARGB(255, 90, 143, 211),
                  decoration: TextDecoration.none,
                  fontSize: 40
                ),),),
        ),
      )
    );

    return SafeArea(
      child: Stack(
        children: list,
      ),
    );
  }
}