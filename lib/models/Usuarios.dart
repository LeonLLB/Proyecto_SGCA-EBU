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

  static final String tableName = 'Usuarios';

  static final String testInitializer = '''
    SELECT id FROM Usuarios;
  ''';

  static final String tableInitializer = '''
  
    CREATE TABLE Usuarios(
      id INT PRIMARY KEY NOT NULL,
      nombres VARCHAR(20) NOT NULL, 
      apellidos VARCHAR(20) NOT NULL,
      cedula INT UNIQUE NOT NULL,
      contraseña VARCHAR(8) NOT NULL,
      correo VARCHAR(50) ,
      numero VARCHAR(11),
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

  Usuarios.fromForm(Map<String,dynamic> usuario) :
    nombres = usuario['Nombres'],
    apellidos = usuario['Apellidos'],
    contrasena = usuario['Contraseña'],
    cedula = int.parse(usuario['Cedula']),
    correo = usuario['Correo'],
    numero = usuario['Numero'],
    direccion = usuario['Direccion'],
    rol = usuario['Rol'];

  Usuarios.fromMap(Map<String, dynamic> usuario) :
    id = usuario['id'],
    nombres = usuario['nombres'],
    apellidos = usuario['apellidos'],
    contrasena = usuario['contraseña'],
    cedula = int.parse(usuario['cedula']),
    correo = usuario['correo'],
    numero = usuario['numero'],
    direccion = usuario['direccion'],
    rol = usuario['rol'];

  Map<String,dynamic> toJson({bool withId = true})=> (withId) ? {
    'id' : id,
    'nombres': nombres, 
    'apellidos': apellidos, 
    'contraseña': hashPassword(contrasena!),
    'cedula': cedula, 
    'correo': correo,
    'numero': numero, 
    'direccion': direccion, 
    'rol': rol
  } : {
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