// ignore: import_of_legacy_library_into_null_safe
import 'package:dbcrypt/dbcrypt.dart';

class Usuarios {

  int? id; 
  String nombres;
  String apellidos;
  String? contrasena;
  int cedula;
  String correo;
  String numero;
  String direccion;
  String rol;

  static const String testInitializer = '''
    SELECT id FROM Usuarios;
  ''';

  static const String tableInitializer = '''
  
    CREATE TABLE Usuarios(
      id INT NOT NULL AUTO_INCREMENT,
      nombres VARCHAR(20) NOT NULL, 
      apellidos VARCHAR(20) NOT NULL,
      cedula INT NOT NULL,
      contraseña VARCHAR(8) NOT NULL,
      correo VARCHAR(50) ,
      numero VARCHAR(11)L,
      direccion VARCHAR(30),
      rol CHAR(1) NOT NULL
    );
  
  ''';

  String hashPassword(String password)
  =>  DBCrypt().hashpw(password, DBCrypt().gensalt());

  // const String comparePassword(){}

  Usuarios({
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.correo,
    this.contrasena,
    required this.numero,
    required this.direccion,
    required this.rol
  });

  Usuarios.fromMap(Map<String, dynamic> usuario) :
    id = usuario['id'],
    nombres = usuario['nombre'],
    apellidos = usuario['apellidos'],
    contrasena = usuario['contrasena'],
    cedula = usuario['cedula'],
    correo = usuario['correo'],
    numero = usuario['numero'],
    direccion = usuario['direccion'],
    rol = usuario['rol'];

  Map<String,dynamic> toJson()=>{
    'id' : id,
    'nombres': nombres, 
    'apellidos': apellidos, 
    'contraseña': hashPassword(contrasena!),
    'cedula': cedula, 
    'correo': correo,
    'numero': numero, 
    'direccion': direccion, 
    'rol': rol
  };

}