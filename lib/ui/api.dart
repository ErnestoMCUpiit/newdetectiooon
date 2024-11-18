import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:newdetectiooon/ui/load_screen.dart';
import 'package:newdetectiooon/ui/weaponWidget.dart';

class Api extends StatefulWidget {
  const Api({ Key? key }) : super(key: key);

  @override
  _ApiState createState() => _ApiState();
}

class _ApiState extends State<Api> {
  List<Map<String, dynamic>> finalWeapons = [];
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchWeapons();
    
  }
  @override
  Widget build(BuildContext context) {
    print("body");
    if (isLoading || finalWeapons.isEmpty) {
      // Mostrar pantalla de carga mientras se obtienen los datos
      return sinCarga();
    }
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 50,
        backgroundColor: Color.fromARGB(255,61, 144, 255),
        title: const Text('Elige tu arma',
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
                itemCount: finalWeapons.length,
                itemBuilder: (BuildContext context, int index){
                  var type = finalWeapons[index];
                    return WeaponWidget(type: type);
                })
            ),]
          ),
      )
    );
  }

//   Padding weaponWidget(Map<String, dynamic> type) {
//   bool isExpanded = false;
//   return Padding(
//     padding: const EdgeInsets.all(10.0),
//     child: AnimatedContainer(
//       duration: const Duration(seconds: 2),
//       curve: Curves.fastOutSlowIn,
//       // decoration: BoxDecoration(
//       //   color: const Color.fromARGB(255, 74, 143, 235),
//       //   borderRadius: BorderRadius.circular(20),
//       // ),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min, // Permitir que la columna ocupe solo el espacio necesario
//           children: [
//             CachedNetworkImage(
//               imageUrl: type["img"],
//               fit: BoxFit.fitWidth,
//             ),
//             // Text(
//             //   type["nombre"].toString(),
//             //   style: const TextStyle(
//             //     fontSize: 35,
//             //     color: Colors.black,
//             //     fontFamily: "quicksand",
//             //     fontWeight: FontWeight.w800,
//             //     decoration: TextDecoration.none,
//             //   ),
//             // ),
//             if (isExpanded)
//               Text(
//                 type["categoria"] ?? "Sin categoría",
//                 style: const TextStyle(
//                   fontSize: 20,
//                   color: Colors.black54,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     ),
//   );
// }


  Future<void> fetchWeapons() async{
    try{
      print("fetch");
    var url = Uri.parse("https://valorant-api.com/v1/weapons?limit=1");
    var response = await http.get(url);
    if(response.statusCode==200){
      //asignar una lista temporal, cuando termine de llenarse asignarse a la lista donde el body va a iterarse
      List<Map<String, dynamic>> weapons = [];
      var decodedJsonData = jsonDecode(response.body);
      List results = decodedJsonData["data"];
      for (var result in results) {
        var nameWeapon = Uri.parse(result["displayName"]);
        // print(nameWeapon);
        Map<String, dynamic> weaponStats = {};
        print(result["weaponStats"]);
        if( result["weaponStats"] != null){
          weaponStats = result["weaponStats"];
        }
        // print(weaponStats);
        String wordToRemove = "EequippableCategory::";
        String categoria = result["category"];
        String categoriaLimpia = removeWord(categoria, wordToRemove);
        var weaponInfo = {
          "nombre": nameWeapon,
          "img" : result["displayIcon"],
          "categoria": categoriaLimpia,
          "magazineSize" : weaponStats["magazineSize"],
          "equipTimeSeconds": weaponStats["equipTimeSeconds"],
          "firstBulletAccuracy": weaponStats["firstBulletAccuracy"],
          "reloadTimeSeconds": weaponStats["reloadTimeSeconds"],
        };
        // print(weaponStats["magazineSize"]);
        // print(weaponInfo);
        weapons.add(weaponInfo);
      }
      setState(() {
        finalWeapons = weapons; // Actualizar la lista finalWeapons
        isLoading = false; // Indicar que ya no estamos cargando
    });
    }}
    catch (e){
      setState(() {
        isLoading = false;
      });
    }
    
  }
  String removeWord(String text, String wordToRemove) {
  // Escapamos la palabra para evitar problemas con caracteres especiales
  final pattern = RegExp('\\b$wordToRemove\\b', caseSensitive: false);
  
  // Reemplazar todas las ocurrencias de la palabra por una cadena vacía
  return text.replaceAll(pattern, '').trim();
}
}