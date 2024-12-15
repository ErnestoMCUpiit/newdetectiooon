// const registroItems = [
//   {"Hora":123, "Lugar":456},
//   {"Hora":17678, "Lugar":456},
//   {"Hora":434, "Lugar":667}
// ];

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegistroPersistente {
  static const String _key = "registroItems";

  // Guardar lista
  static Future<void> saveRegistroItems(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(items); // Convierte la lista a JSON
    await prefs.setString(_key, jsonString);
  }

  // Cargar lista
  static Future<List<Map<String, dynamic>>> loadRegistroItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_key);
    if (jsonString == null) {
      return []; // Si no hay datos, devuelve una lista vacía
    }
    List<dynamic> jsonList = jsonDecode(jsonString); // Convierte el JSON a lista
    return jsonList.cast<Map<String, dynamic>>(); // Asegura el tipo
  }
}

var now = DateTime.now().toUtc();
var noww = now.toLocal();
List<Map<String, dynamic>> registroItems = [
    {"Anio": noww.year,
    "Mes": noww.month,
    "Dia": noww.day,
    "Hora":noww.hour,
    "minuto": noww.minute,
    "Lugar":"aqui"}
]; 

String intToString(int mes){
  List<String> meses = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];
  return meses[mes-1];
}