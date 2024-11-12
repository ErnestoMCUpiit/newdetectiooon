import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Selection extends StatefulWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  static const Duration duration = Duration(seconds: 1);
  static const Curve curve = Curves.fastOutSlowIn;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    // Cambia el estado de selected a true cuando la pantalla se construye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        
        children: [
          // Fondo de pantalla
          Container(
            width: screenSize.width , // 80% del ancho de la pantalla
            height: screenSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Botón animado con Stack y AnimatedPositioned
          AnimatedPositioned(
            duration: duration,
            curve: curve,
            top: selected ? 300 : -100, // Inicia fuera de la pantalla, luego baja
            left: MediaQuery.of(context).size.width / 5, // Centrado horizontalmente
            child: ElevatedButton.icon(
              onPressed: () {
                context.go("/load", extra: "/gallery");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 183, 208, 238),
                fixedSize: const Size.fromWidth(250),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(
                Icons.photo_camera_rounded,
                size: 40,
                color: Color.fromARGB(255, 20, 44, 92),
              ),
              label: const Text(
                "Modo captura",
                style: TextStyle(
                  fontSize: 27,
                  color: Color.fromARGB(255, 35, 47, 58),
                ),
              ),
            ),
          ),
          // Otro botón debajo
          AnimatedPositioned(
            duration: duration,
            curve: curve,
            top: selected ? 500 : -100, // Inicia fuera de la pantalla, luego baja
            left: MediaQuery.of(context).size.width / 5, // Centrado horizontalmente
            child: ElevatedButton.icon(
              onPressed: () {
                context.go("/load", extra: "/live",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 183, 208, 238),
                fixedSize: const Size.fromWidth(250),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(
                Icons.camera,
                size: 40,
                color: Color.fromARGB(255, 20, 44, 92),
              ),
              label: const Text(
                "Modo centinela",
                style: TextStyle(
                  fontSize: 27,
                  color: Color.fromARGB(255, 35, 47, 58),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class SharedData {
  // Usamos ValueNotifier para que los cambios sean escuchados
  ValueNotifier<int> state = ValueNotifier<int>(0);
}