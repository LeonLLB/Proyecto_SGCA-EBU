

int calcularEdad(dynamic fechaNacimiento){
  DateTime fechaNacimientoPulida = (fechaNacimiento.runtimeType == String) ?
    DateTime(int.parse(fechaNacimiento.split('/')[2]),int.parse(fechaNacimiento.split('/')[1]),int.parse(fechaNacimiento.split('/')[0])):
    fechaNacimiento as DateTime
  ;


  DateTime fechaActual = DateTime.now();
  if(
    fechaNacimientoPulida.month < fechaActual.month ||
    fechaNacimientoPulida.month == fechaActual.month && fechaNacimientoPulida.day >= fechaActual.day
  ) return fechaActual.year - fechaNacimientoPulida.year;
  else return fechaActual.year - fechaNacimientoPulida.year - 1;
}