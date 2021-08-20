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

  Usuario.fromJSON(Map<String, dynamic> usuario)
      : nombres = usuario['Nombres'],
        apellidos = usuario['Apellidos'],
        cedula = usuario['Cedula'],
        correo = usuario['Correo'],
        numero = usuario['Telefono'],
        direccion = usuario['Direccion'],
        rol = usuario['Rango'],
        id = usuario['id'],
        password = usuario['Contraseña'];

  Map<String, dynamic> toJson() => {
        'nombres': this.nombres,
        'apellidos': this.apellidos,
        'cedula': this.cedula,
        'correo': this.correo,
        'numero': this.numero,
        'direccion': this.direccion,
        'rol': this.rol,
        'id': this.id,
      };
}
