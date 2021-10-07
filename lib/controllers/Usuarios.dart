import 'package:proyecto_sgca_ebu/models/Usuarios.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _UsuariosControllers {

  Future<bool> existenAdministradores() async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Usuarios.tableName,where: 'rol = ?',whereArgs: ['A']);

    return (result.isEmpty && result.length == 0);
  }

  Future<int> registrar(Usuarios usuario) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.insert(Usuarios.tableName, usuario.toJson(withId: false));
    db.close();
    return result;
    
  }

}

final controladorUsuario = _UsuariosControllers();