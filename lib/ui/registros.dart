import 'package:flutter/material.dart';
import 'package:newdetectiooon/helper/registration.dart';
import 'package:newdetectiooon/helper/registroItem.dart';

class Registros extends StatefulWidget {
  const Registros({ Key? key }) : super(key: key);

  @override
  _RegistrosState createState() => _RegistrosState();
}

class _RegistrosState extends State<Registros> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 50,
        backgroundColor: const Color.fromARGB(255,61, 144, 255),
        title: const Text('Registros de detecciones',
        style: TextStyle(
                  fontFamily: "quicksand",
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 0, 6, 14),
                  decoration: TextDecoration.none
                ),),
      ),
      body: Container(
        color: Color.fromARGB(255,4, 89, 203),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: registroItems.length,
                itemBuilder: (BuildContext context, int index){
                  var registro = registroItems[index];
                    return RegistroItem(registro: registro);
                }))
          ],
        )
      ),
    );
  }
}