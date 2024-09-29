List<String> data = [
  "Samuel Colt patentó el primer revólver de seis tiros, lo que cambió por completo las armas, ya que antes era necesario recargar después de cada disparo",
  "Los primeros lanzallamas fueron usados en la Primera Guerra Mundial",
  "se estima que entre el 70% y el 90% de las armas usadas por los cárteles provienen de Estados Unidos",
  "El Mondragón fue uno de los primeros fusiles semiautomáticos utilizados en combate a nivel mundial.",
  "El FX-05 es el actual de asalto del Ejército mexicano. Fue creado por la Industria Militar Mexicana (D.I.M)"
];

String randomData(){
  String randomItem = (data.toList()..shuffle()).first;
  return randomItem;
}