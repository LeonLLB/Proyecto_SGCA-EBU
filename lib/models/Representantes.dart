class Representante {
  int? id;
  final String nombres;
  final String apellidos;
  final String ubicacion;
  final String cedula;
  final String telefono;

  Representante(
      {this.id,
      required this.nombres,
      required this.apellidos,
      required this.ubicacion,
      required this.cedula,
      required this.telefono});

  Representante.fromJson(Map<String, dynamic> representante)
      : id = representante['id'],
        nombres = representante['Nombres'],
        apellidos = representante['Apellidos'],
        ubicacion = representante['Ubicacion'],
        cedula = representante['Cedula'],
        telefono = representante['Telefono'];

  Map<String, String> toJson() => {
        'id': id.toString(),
        'nombres': nombres,
        'apellidos': apellidos,
        'ubicacion': ubicacion,
        'cedula': cedula,
        'telefono': telefono
      };
}
