import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeaponWidget extends StatefulWidget {
  final Map<String, dynamic> type;

  const WeaponWidget({super.key, required this.type});

  @override
  _WeaponWidgetState createState() => _WeaponWidgetState();
}

class _WeaponWidgetState extends State<WeaponWidget> {
  bool isExpanded = false;  // Variable para controlar la expansión
  
  @override
  Widget build(BuildContext context) {
    final details = [
      {"label": "Categoría", "value": widget.type["categoria"] ?? "N/A"},
      {"label": "Capacidad", "value": widget.type["magazineSize"] ?? "N/A"},
      {"label": "Equipamiento", "value": "${widget.type["equipTimeSeconds"]} s"?? "N/A"},
      {"label": "Recarga", "value": "${widget.type["reloadTimeSeconds"]} s"?? "N/A"},
      {"label": "Precisión", "value": widget.type["firstBulletAccuracy"] ?? "N/A"},
    ];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if(isExpanded){
              isExpanded = !isExpanded; 
            }
            isExpanded = !isExpanded;  // Alternar el estado de expansión
          });
        },
        child: AnimatedContainer(
          // width: double.infinity, // Ancho flexible para el widget
          height: isExpanded ? 450.0 : 200.0,  // Cambiar altura dependiendo de si está expandido
          duration: const Duration(milliseconds: 1000),  // Duración de la animación
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 74, 143, 235),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: widget.type["img"],
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.type["nombre"].toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontFamily: "quicksand",
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.none,
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      
                      mainAxisSpacing: 10,
                      padding: const EdgeInsets.fromLTRB(0,10,0,10),
                      childAspectRatio: 3.4,// Ajusta el tamaño de las celdas
                      children: details.map<Widget>((details) {
                        return Container(
                          
                          decoration: BoxDecoration( 
                            color: const Color.fromARGB(255, 122, 177, 248),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            
                            children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(7), topLeft: Radius.circular(7)),
                                ),
                                child: Text(
                                  details["label"]!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(

                                ),
                                child: Text(
                                  details["value"].toString()!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "quicksand",
                                    ),
                                ),
                              ),
                            ),
                              ],),
                            );
                    }).toList(),
                    ),
                  ),
                  // Text("Categoría: ${widget.type["categoria"] ?? 'N/A'}"),
                  // Text("Tamaño del cargador: ${widget.type['magazineSize']}"),
                  // Text("Tiempo de equipamiento: ${widget.type['equipTimeSeconds']} s"),
                  // Text("Tiempo de recarga:  ${widget.type['reloadTimeSeconds']} s"),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
