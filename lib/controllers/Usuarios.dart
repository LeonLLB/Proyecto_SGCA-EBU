import 'package:proyecto_sgca_ebu/models/Usuarios.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _UsuariosControllers {

  Future<int> registrar(Usuarios usuario) async {
    final db = await databaseFactoryFfi.openDatabase('sgca_ebu_database.db');

    final result = await db.insert('usuarios', usuario.toJson());
    db.close();
    return result;
    
  }

}

final controladorUsuario = _UsuariosControllers();