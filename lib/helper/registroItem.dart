import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newdetectiooon/helper/registration.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistroItem extends StatefulWidget {
  final Map<String, dynamic> registro;
  const RegistroItem({ Key? key , required this.registro}) : super(key: key);

  @override
  _RegistroItemState createState() => _RegistroItemState();
}

class _RegistroItemState extends State<RegistroItem> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>registroLista = {
      "Anio": widget.registro["Anio"],
      "Mes": widget.registro["Mes"],
      "Dia": widget.registro["Dia"],
      "Hora":widget.registro["Hora"], 
      "Minuto": widget.registro["minuto"],
      "Lugar":widget.registro["Lugar"]};
      
    return Container(
      color: const Color.fromARGB(255, 122, 177, 248),
      child: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              
              // tituloRegistro(titulo: "Fecha"),
              Text("${registroLista["Dia"].toString()} de ${intToString(registroLista["Mes"])}, ${registroLista["Anio"].toString()}",
              style: registroDatosTextstilo(),),
              // tituloRegistro(titulo: "Hora"),
              Text("${registroLista["Hora"].toString()}:${registroLista["Minuto"].toString()}",
              style: registroDatosTextstilo()),
              // Text("LUGAR"),
              // Text(registroLista["Lugar"].toString(),
              // style: registroDatosTextstilo()),
              IconButton(
              onPressed:(){
                // context.go("/registros");
                log("link = ${registroLista["Lugar"]}");
                launchUrl(Uri.parse(registroLista["Lugar"]));
              } , 
              icon: const Icon(Icons.location_pin,
                        color: Color.fromARGB(255, 13, 59, 116),
                        size:40.0,)),
              // Text(registroLista["Hora"].toString()),
              // Text(registroLista["Lugar"].toString()),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle registroDatosTextstilo() => const TextStyle(
    // color:Colors.black,
      fontSize: 18,
      color: Colors.black,
      fontFamily: "quicksand",
      // fontWeight: FontWeight,
      decoration: TextDecoration.none,);
}

