import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:newdetectiooon/ui/capture_button.dart';

class Gallery extends StatefulWidget {
  final CameraDescription camera;
  const Gallery({ super.key,
    required this.camera, });

  @override
  _GalleryState createState() => _GalleryState();
}


class _GalleryState extends State<Gallery>
with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  
  late CameraController cameraController;
  
  bool _isProcessing = false;

  late CameraImage _cameraImage;
  Uint8List? capturedImage;
  

  List<Widget> iconStates = [
    loading(), verdadero(), falso()
  ];
  int changeState = 0;

   initCamera() {
    cameraController = CameraController(widget.camera, ResolutionPreset.medium,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420);
    cameraController.initialize().then((value) {
      // cameraController.startImageStream(imageAnalysis);
      cameraController.startImageStream((image) => _cameraImage = image);
      
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
  
  void capture(int newState) {
    setState(() {
      changeState = newState; // Actualiza el estado cuando el botón se presiona
    });
    if (_cameraImage != null) {
      img.Image image = _convertYUV420toImage(_cameraImage);
      List<int> jpegBytes = img.encodeJpg(image); // Codificar la imagen a formato JPEG
      capturedImage = Uint8List?.fromList(jpegBytes); // Guardar la imagen en Uint8List

    
    
    print("Imagen capturada y convertida a JPEG");
    }
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
    return Scaffold(
      body: Container(
        child: Stack(
          children: [Column(
            children: [
              Expanded(
                flex: 75,
                child: cameraWidget(context),
                
                // Container(
                // width: MediaQuery.of(context).size.width,
                // height: 700,
                // color: Colors.green,
                
              ),
              Expanded(
                flex: 25,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color.fromARGB(255, 35, 47, 58),
                  child: Padding(padding: EdgeInsets.all(25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(83, 148, 223, 1),
                        borderRadius: BorderRadius.circular(12)),
                        child: iconStates[changeState],
                    ),),
                ),
              )
            ],),
            Positioned(
              bottom: 180,
              left: MediaQuery.of(context).size.height /5.4,
              child: CaptureButton(capture),
              )]
        ),
      ),
    );
  }

static img.Image _convertYUV420toImage(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: imageWidth, height: imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }

    return image;
  }
  
  int _clamp(int val) {
    return val < 0 ? 0 : (val > 255 ? 255 : val);
  }
  
}

class loading extends StatelessWidget {
  const loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return LoadingAnimationWidget.dotsTriangle(color:Color(0xFFF8F8FF),size: 50);
  }
}

class falso extends StatelessWidget {
  const falso({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Icon(Icons.warning, color: Color.fromRGBO(218, 5, 27, 0.898), size: 70,);
  }
}

class verdadero extends StatelessWidget {
  const verdadero({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Icon(Icons.done_outline_outlined, color: Colors.white, size: 70,);
  }
}

