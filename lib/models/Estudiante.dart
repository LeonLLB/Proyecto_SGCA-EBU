class Estudiante {
  int? id;
  final String nombres;
  final String apellidos;
  final String lugarNacimiento;
  final DateTime fechaNacimiento;
  final String genero;
  final String cedulaEscolar;
  final String procedencia;
  final String tipo;

  Estudiante(
      {this.id,
      required this.nombres,
      required this.apellidos,
      required this.lugarNacimiento,
      required this.fechaNacimiento,
      required this.genero,
      required this.cedulaEscolar,
      required this.procedencia,
      required this.tipo});

  Estudiante.fromJson(Map<String, dynamic> estudiante)
      : nombres = estudiante['Nombres'],
        apellidos = estudiante['Apellidos'],
        lugarNacimiento = estudiante['LugarNacimiento'],
        fechaNacimiento = DateTime(estudiante['FechaNacimiento']),
        genero = estudiante['Genero'],
        cedulaEscolar = estudiante['CedulaEscolar'],
        procedencia = estudiante['Procedencia'],
        tipo = estudiante['Tipo'];

  Map<String, String> toJson() => {
        'nombres': nombres,
        'apellido': apellidos,
        'lugarNacimiento': lugarNacimiento,
        'fechaNacimiento': fechaNacimiento.toString(),
        'genero': genero,
        'cedulaEscolar': cedulaEscolar,
        'procedencia': procedencia,
        'tipo': tipo
      };
}
