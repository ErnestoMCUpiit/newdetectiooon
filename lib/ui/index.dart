import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Index extends StatefulWidget {
  const Index({ Key? key }) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  static const Duration duration = Duration(seconds: 2);
  static const Curve curve = Curves.fastOutSlowIn;
  bool selected = false;
 bool showText = false;

  @override
  void initState() {
    super.initState();
    // Cambia el estado de selected a true cuando la pantalla se construye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selected = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          showText = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(255, 110, 161, 219),
        ),
        AnimatedPositioned(
          width: MediaQuery.of(context).size.width - 200,
          left: MediaQuery.of(context).size.width /4,
          top: selected ? 180 : -100, 
          duration: duration,
          curve: curve,
          child: const Image(
            fit: BoxFit.cover,
            image: AssetImage("assets/index.png"),),),
        if (showText)
          Positioned(
            bottom: 420,
            left: (MediaQuery.of(context).size.width - 200) / 3,
            child: Container(
              width: 300,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('A la vanguardia de tu seguridad',
                  
                  speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontFamily: "quicksand",
                      color: Color.fromARGB(255, 43, 74, 95),
                      decoration: TextDecoration.none)),
                  
                ],
                totalRepeatCount: 1, // Hace que la animación se ejecute solo una vez
                  isRepeatingAnimation: false),
            )
          ),
          AnimatedPositioned(
            duration: duration,
            curve: curve,
            bottom: selected ? 300 : -150, // Inicia fuera de la pantalla, luego baja
            width: MediaQuery.of(context).size.width - 200,
            left: MediaQuery.of(context).size.width /4, // Centrado horizontalmente
            child: ElevatedButton(
              onPressed: () {
                // context.go("/load", extra: "/gallery");
                context.go("/select");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 183, 208, 238),
                fixedSize: const Size.fromWidth(200),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Iniciar",
                style: TextStyle(
                  fontSize: 27,
                  color: Color.fromARGB(255, 35, 47, 58),
                ),
              ),
            ),
          ),
      ],
      
    );
  }
}