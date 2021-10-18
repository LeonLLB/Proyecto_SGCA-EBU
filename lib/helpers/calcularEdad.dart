

int calcularEdad(dynamic fechaNacimiento){
  DateTime fechaNacimientoPulida = (fechaNacimiento.runtimeType == String) ?
    DateTime(fechaNacimiento.split('/')[2],fechaNacimiento.split('/')[1],fechaNacimiento.split('/')[0]):
    fechaNacimiento as DateTime
  ;


  DateTime fechaActual = DateTime.now();
  if(fechaNacimientoPulida.month < fechaActual.month) 
    return fechaActual.year - fechaNacimientoPulida.year;
  else if(fechaNacimientoPulida.month == fechaActual.month && fechaNacimientoPulida.day >= fechaActual.day)
    return fechaActual.year - fechaNacimientoPulida.year;
  else return fechaActual.year - fechaNacimientoPulida.year - 1;
}