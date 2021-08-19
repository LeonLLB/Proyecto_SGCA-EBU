class Usuario {
  String? id;
  final String nombres;
  final String apellidos;
  final String cedula;
  final String correo;
  final String numero;
  final String direccion;
  String? password;
  final String rol;

  Usuario(
      {this.id,
      required this.nombres,
      required this.apellidos,
      required this.cedula,
      required this.correo,
      required this.numero,
      this.password,
      required this.direccion,
      required this.rol});

  /* Usuario.fromMap(Map<String, String> usuario) {
    if (usuario['id'] != null) {
      this.id = usuario['id'];
    }
    if (usuario['Contraseña'] != null) {
      this.password = usuario['Contraseña'];
    }
    this.nombres = usuario['Nombres'];
    this.apellidos = usuario['Apellidos'];
    this.cedula = usuario['Cedula'];
    this.correo = usuario['Correo'];
    this.numero = usuario['Telefono'];
    this.direccion = usuario['Direccion'];
    this.rol = usuario['Rango'];
  } */
}
