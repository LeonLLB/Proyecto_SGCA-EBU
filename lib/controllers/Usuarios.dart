import 'package:proyecto_sgca_ebu/models/Usuarios.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _UsuariosControllers {

  Future<bool> existenAdministradores() async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Usuarios.tableName,where: 'rol = ?',whereArgs: ['A']);

    db.close();
    return (result.isEmpty && result.length == 0);

  }

  Future<Map<String,dynamic>> login({required int cedula, required String password}) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Usuarios.tableName,where:'cedula = ?',whereArgs: [cedula]);

    db.close();

    if(result.length == 0){
      return {
        'logged': false,
        'error': 'No existe el usuario'
      };
    }

    final Usuarios usuario = Usuarios.fromMap(result[0]);

    if(usuario.comparePassword(password)){
      return {
        'logged':true,
        'usuario':usuario
      };
    }
    else{
      return {
        'logged': false,
        'error': 'Usuario o clave invalida'
      };
    }

  }

  Future<int> registrar(Usuarios usuario) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.insert(Usuarios.tableName, usuario.toJson(withId: false));
    db.close();
    return result;
    
  }

}

final controladorUsuario = _UsuariosControllers();