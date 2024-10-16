import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newdetectiooon/ui/load_screen.dart';

class Api extends StatefulWidget {
  const Api({ Key? key }) : super(key: key);

  @override
  _ApiState createState() => _ApiState();
}

class _ApiState extends State<Api> {
  List<Map<String, dynamic>> finalWeapons = [];
  @override
  void initState(){
    super.initState();
    fetchWeapons();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchWeapons(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            return Container(
              decoration: BoxDecoration(color: Colors.black),
            );
          }
        },),
    );
  }

  Future<void> fetchWeapons() async{
    var url = Uri.parse("https://valorant-api.com/v1/weapons?limit=1");
    http.get(url).then((value) {
      if(value.statusCode==200){
        var decodedJsonData = jsonDecode(value.body);
        print(decodedJsonData);
        List results = decodedJsonData["data"];
        results.forEach((result) {
          var nameWeapon = Uri.parse(result["displayName"]);
          print(nameWeapon);
          Map<String, dynamic> weaponStats = result["weaponStats"];
          // print(weaponStats);
          var weaponInfo = {
            "nombre": nameWeapon,
            "img" : result["displayIcon"],
            "magazineSize" : weaponStats["magazineSize"],
            "equipTimeSeconds": weaponStats["equipTimeSeconds"],
            "firstBulletAccuracy ": weaponStats["firstBulletAccuracy"],
            "reloadTimeSeconds": weaponStats["reloadTimeSeconds"],
          };
          // print(weaponStats["magazineSize"]);
          print(weaponInfo);
          setState(() {
            finalWeapons.add(weaponInfo);
          });
        });
      }
    });
  }
}