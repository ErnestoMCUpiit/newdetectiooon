import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:newdetectiooon/ui/capture_button.dart';

class Gallery extends StatefulWidget {
  const Gallery({ super.key });

  @override
  _GalleryState createState() => _GalleryState();
}


class _GalleryState extends State<Gallery> {

  List<Widget> iconStates = [
    loading(), verdadero(), falso()
  ];
  int changeState = 0;
  void updateState(int newState) {
    setState(() {
      changeState = newState; // Actualiza el estado cuando el botón se presiona
    });
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
                child: Container(
                width: MediaQuery.of(context).size.width,
                height: 700,
                color: Colors.green,
                                ),
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
              child: CaptureButton(updateState),
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

