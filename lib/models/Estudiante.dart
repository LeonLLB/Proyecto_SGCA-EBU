class Estudiante {
  int? id;
  final String nombres;
  final String apellidos;
  final String lugarNacimiento;
  final DateTime fechaNacimiento;
  final String genero;
  String? cedulaEscolar;

  set cedula(String cedula) {
    cedulaEscolar = cedula;
  }

  Estudiante({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.lugarNacimiento,
    required this.fechaNacimiento,
    required this.genero,
    this.cedulaEscolar,
  });

  Estudiante.fromJson(Map<String, dynamic> estudiante)
      : nombres = estudiante['Nombres'],
        id = estudiante['id'],
        apellidos = estudiante['Apellidos'],
        lugarNacimiento = estudiante['LugarNacimiento'],
        fechaNacimiento = DateTime.parse(estudiante['FechaNacimiento']),
        genero = estudiante['Genero'];

  Map<String, String> toJsonData() => {
        'Nombres': nombres,
        'Apellido': apellidos,
        'Lugar_Nacimiento': lugarNacimiento,
        'Fecha_Nacimiento': fechaNacimiento.toString(),
        'Genero': genero,
        'Cedula': cedulaEscolar!,
      };
}
