
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:newdetectiooon/ui/gallery.dart';
import 'package:newdetectiooon/ui/index.dart';
import 'package:newdetectiooon/ui/live_camera.dart';
import 'package:newdetectiooon/ui/load_screen.dart';
import 'package:newdetectiooon/ui/selection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

 
  runApp(const MyApp());
}
Future initialization (BuildContext context) async{
  await Future.delayed(Duration(seconds: 4));
}


class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Example(),);
  }
}

class Example extends StatefulWidget{
  const Example({super.key});
  
  @override
  State<Example> createState() =>
    ExampleState();
}
late CameraDescription cameraDescription;

class ExampleState  extends State<Example>{

 
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPages();
    });
  }


  @override 
  Widget build(BuildContext context){
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // home: const CameraScreen(),
      routerConfig: _router,
      title: "detección de peligros",
      // initialBinding: GlobalBindings(),
    );
  }
  
  initPages()  async{
    if (cameraIsAvailable) {
      // get list available camera
      cameraDescription = (await availableCameras()).first;
      
    }
    setState(() {});
  }
  
}
final _router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Index(),
      routes: [
            GoRoute(
              path: 'select',
              builder: (context, state) {
                return Selection();
              },),
            GoRoute(
              path: 'load',
              builder: (context, state) {
                final String destinationRoute = state.extra as String;
                return loadScreen(destinationRoute: destinationRoute);
              },),
            GoRoute(
              path: "gallery",
              builder: (context, state) => Gallery(),
              
              ),
           GoRoute(
            path: "live",
            builder: (context, state) => LiveCamera(camera: cameraDescription),
            )
            
      ]
    ),
    
  ],
);

