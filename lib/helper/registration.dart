// const registroItems = [
//   {"Hora":123, "Lugar":456},
//   {"Hora":17678, "Lugar":456},
//   {"Hora":434, "Lugar":667}
// ];
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