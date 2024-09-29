import 'package:flutter/material.dart';

class CaptureButton extends StatefulWidget {
  final Function(int) onPressed;
  const CaptureButton( this.onPressed,{ Key? key }) : super(key: key);

  
  
  @override
  _CaptureButtonState createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  int actualState = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (actualState == 0){
          actualState = 1;
        }
        else if(actualState == 1){
          actualState = 2;
        }
        else if(actualState == 2){
          actualState = 0;
        }
        widget.onPressed(actualState);
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Color.fromARGB(100, 255, 255, 255),
          border: Border.all(color: const Color.fromARGB(255, 20, 44, 92), width: 5),
          shape: BoxShape.circle
        ),
        child: const Center(
          child: Icon(Icons.camera, size: 60,),
        ),
      ),
    );
  }
}