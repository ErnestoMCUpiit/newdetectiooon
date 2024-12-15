import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:newdetectiooon/helper/image_classification_helper.dart';
import 'package:newdetectiooon/helper/registration.dart';
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
  ImageClassificationHelper? imageClassificationHelper;
  late List<CameraDescription> _cameras;
  List<double>? classification;
  img.Image? image;
  img.Image? imageToPredict;
  String? imagePath;
  
  late CameraController cameraController;
    late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;

  CameraImage? _cameraImage;
  Uint8List? capturedImage;
  

  List<Widget> iconStates = [
    loading(), verdadero(), falso()
  ];
  int changeState = 0;


  Future<Position> posicionDeterminada() async{
    LocationPermission permisos;
    permisos = await Geolocator.checkPermission();
    if(permisos == LocationPermission.denied){
      permisos = await Geolocator.requestPermission();
      if (permisos == LocationPermission.denied){
        context.go("/select");
        return Future.error("error permisos");
        
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getCurrentLocation ()async{
    Position posicionChida = await posicionDeterminada();

    double latitud = posicionChida.latitude;
    double longitud = posicionChida.longitude;

    // Construir el enlace de Google Maps
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitud,$longitud";

    log("Coordenadas");
    log(posicionChida.toString());
    log("Google Maps Link: $googleMapsUrl");

    return googleMapsUrl.toString();
    // log("Coordenadas");
    // log(posicionChida.toString());
  }
  void initCamera() async {
    cameraController = CameraController(
      widget.camera, ResolutionPreset.medium,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420);
    _initializeControllerFuture = cameraController.initialize();
    await cameraController.initialize().then((value) {
      log("camara lista");
      if (!mounted) {
        return;
      }
      // cameraController.startImageStream(imageAnalysis);
      // cameraController.startImageStream((image) => _cameraImage = image);
      cameraController.startImageStream((CameraImage image) async {
        // cameraController.stopImageStream();
        setState(() {
          log("cameraImage actualizado");
          _cameraImage = image;
        });
        // imageAnalysis(cameraImage);
        

        _isProcessing = false;
      });
      
      
    });
    if (mounted) {
        setState(() {});
      }
  }
  Future<void> imageAnalysis(CameraImage? cameraImage) async {
    // log("BOTON PRESIONADO");
    log('Análisis');
    // if image is still analyze, skip this frame
    // if (_isProcessing) {
    //   return;
    // }
    _isProcessing = true;
    classification =
        await imageClassificationHelper?.inferenceCameraFrame(cameraImage!);
    log("Clasificación: $classification");
    _isProcessing = false;
    if (mounted) {
      setState(() {});
    }
  }
  // Clean old results when press some take picture button
  void cleanResult() {
    
    image = null;
    classification = null;
    setState(() {});
  }


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    log('Cámara inicializando');
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
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
    RegistroPersistente.saveRegistroItems(registroItems);
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    imageClassificationHelper!.close();
    super.dispose();
    log("instancias cerradas");
  }
  
  Future<void> capture(int newState) async {
    try {
      Map<String, dynamic> registro ;
      log("Botón presionado para tomar foto");

      final XFile capturedFile = await cameraController.takePicture();
      log("Foto tomada: ${capturedFile.path}");
      
      //decodificar la imagen 
      final img.Image? capturedImage = await processXFileToImage(capturedFile);
      print("w w = ${capturedImage!.width}");
      print("w h = ${capturedImage!.height}");
      if (capturedImage != null) {
        log("Imagen capturada y decodificada correctamente");

        final classification =
            await imageClassificationHelper?.inferenceImage(capturedImage);
        log("Clasificación de la imagen: ${classification![0]}");
        if(classification[0]>=0.65){
          String link = await getCurrentLocation();
          setState(() {
            var now = DateTime.now().toUtc();
            now = now.toLocal();
            registro = {
              "Anio": now.year,
              "Mes": now.month,
              "Dia": now.day,
              "Hora":now.hour,
              "minuto": now.minute,
              "Lugar":link.toString()};
            // log(now.toString());
            registroItems.add(registro);
            changeState = 2; // Actualiza el estado cuando el botón se presiona
            registro = {};
          });
        }
        else{ 
          setState(() {
            changeState = 0; // Actualiza el estado cuando el botón se presiona
          });
        }
        
      } else {
        log("Error al procesar la imagen capturada.");
      }
    } catch (e) {
      log("Error al tomar la foto: $e");
    }
  }
   Widget cameraWidget(context) {
    var camera = cameraController.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;
    cameraController.initialize();
    if (!cameraController.value.isInitialized) {
      return Center(child: Text("Cámara no inicializada"));
    }
    if (camera.aspectRatio == null) {
      return Center(child: Text("Error: Aspecto de la cámara no disponible"));
    }
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

Future<img.Image?> processXFileToImage(XFile xFile) async {
  try {
    // Leer los bytes de la imagen desde el archivo
    Uint8List imageBytes = await xFile.readAsBytes();

    // Decodificar la imagen en un objeto manipulable usando el paquete `image`
    img.Image? decodedImage = img.decodeImage(imageBytes);

    if (decodedImage != null) {
      print("Imagen decodificada correctamente");
      return decodedImage;
    } else {
      print("Error al decodificar la imagen");
      return null;
    }
  } catch (e) {
    print("Error al procesar la imagen: $e");
    return null;
  }
}
