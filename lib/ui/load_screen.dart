
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:newdetectiooon/ui/data.dart';


// ignore: camel_case_types
class loadScreen extends StatefulWidget {
  final String destinationRoute;
  const loadScreen({super.key,required this.destinationRoute});

  @override
  State<loadScreen> createState() => loadScree();
}

class loadScree extends State<loadScreen> {
  @override
  void initState() {
    super.initState();

    // Esperar n segundos y luego navegar a la ruta de destino
    Future.delayed(Duration(seconds: 3), () {
      context.go(widget.destinationRoute); // Navegar a la ruta pasada como parámetro
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 20, 44, 92),
      child:  Padding(padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 150),
              child: Text("¿Sabías que?",
                style: TextStyle(
                  fontFamily: "quicksand",
                  color: Color.fromARGB(255, 90, 143, 211),
                  decoration: TextDecoration.none
                ),),
            ),
            LoadingAnimationWidget.fourRotatingDots(color:Color(0xFFF8F8FF),size: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 150, 20, 0),
              child: Text(randomData(),
              textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "quicksand",
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 197, 218, 247),
                  decoration: TextDecoration.none,
                  fontSize: 20
                ),),
            ),
          ],
        )),
    );
  }
}