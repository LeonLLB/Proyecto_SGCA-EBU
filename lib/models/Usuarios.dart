class Usuarios {
  final int id;
  final String nombres;
  final String apellidos;
  final String cedula;
  final String correo;
  final String numero;
  final String direccion;
  final String rol;

  Usuarios(
      {required this.id,
      required this.nombres,
      required this.apellidos,
      required this.cedula,
      required this.correo,
      required this.numero,
      required this.direccion,
      required this.rol});
}
