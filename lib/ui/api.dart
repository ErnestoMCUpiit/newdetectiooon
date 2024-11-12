import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:newdetectiooon/ui/load_screen.dart';

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
      body: Column(
          children: [
            Expanded(
            
            child: ListView.builder(
              itemCount: finalWeapons.length,
              itemBuilder: (BuildContext context, int index){
                var type = finalWeapons[index];
                  return weaponWidget(type);
              })
          ),]
        )
    );
  }

  Padding weaponWidget(Map<String, dynamic> type) {
    return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      CachedNetworkImage(imageUrl: type["img"],
                          fit: BoxFit.fitHeight,
                          ),
                      Text(type["nombre"].toString(),
                      style: TextStyle(
                        color: Colors.black
                      ),),

                    ],
                  ),
                );
  }

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
        var weaponInfo = {
          "nombre": nameWeapon,
          "img" : result["displayIcon"],
          "categoria": result["category"],
          "magazineSize" : weaponStats["magazineSize"],
          "equipTimeSeconds": weaponStats["equipTimeSeconds"],
          "firstBulletAccuracy ": weaponStats["firstBulletAccuracy"],
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
}