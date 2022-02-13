import 'package:proyecto_sgca_ebu/models/Matricula_Docente.dart';
import 'package:proyecto_sgca_ebu/models/Usuarios.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _UsuariosControllers {

  Future<bool> existenAdministradores() async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = await db.query(Usuarios.tableName,where: 'rol = ?',whereArgs: ['A']);

    db.close();
    return (result.isEmpty && result.length == 0);

  }

  Future<List<Usuarios>?> buscarDocentes(int? cedula) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final resultados = await db.query(Usuarios.tableName,where: 'rol = ? AND CAST(cedula AS TEXT) LIKE ?',whereArgs: ['D','%${cedula != null ? cedula:""}%']);
    if(resultados.length == 0) return null;
    List<Usuarios> results = [];
    for(var docente in resultados){
      results.add(Usuarios.fromMap(docente));
    }
    db.close();
    return results;

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

  Future<int> contarDocentes()async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

    final result = (await db.rawQuery(Usuarios.contarDocentes))[0];

    return result['cantidadDocentes'] as int;
  }

  Future<Usuarios?> buscarDocente(int? cedulaDocente,[bool closeDB = true])async{

    if(cedulaDocente == null) return null;

    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.query(Usuarios.tableName,where:'rol = ? AND cedula = ?',whereArgs:['D',cedulaDocente]);
    if(closeDB){db.close();}
    return (result.length == 0) ? null : Usuarios.fromMap(result[0]);  
  }

  Future<Usuarios?> buscarAdmin(int? cedulaAdmin,[bool closeDB = true]) async {
    if(cedulaAdmin == null) return null;
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.query(Usuarios.tableName,where:'rol = ? AND cedula = ?',whereArgs:['A',cedulaAdmin]);
    if(closeDB){db.close();}
    return (result.length == 0) ? null : Usuarios.fromMap(result[0]); 
  }

  Future<int> eliminarDocente(int docenteID) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final resultMatricula = await db.query(MatriculaDocente.tableName,where:'docenteID = ?',whereArgs:[docenteID]);

    if(resultMatricula.length > 0){
      await db.close();
      return -1;
    }
    final result = await db.delete(Usuarios.tableName,where:'rol = ? AND id = ?',whereArgs:['D',docenteID]);
    
    await db.close();

    return result;
  }

  Future<int> actualizarUsuario(Map<String,dynamic> usuarioNuevo, String rol) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.update(Usuarios.tableName,usuarioNuevo,where:'rol = ? AND id = ?',whereArgs:[rol,usuarioNuevo['id']]);
    await db.close();
    return result;
  }

  Future<int> cambiarContrasena(String unhashedPassword,int userID,String rol) async{
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    final result = await db.update(Usuarios.tableName,{'contraseña':Usuarios.hashPassword(unhashedPassword)},where:'rol = ? AND id = ?',whereArgs:[rol,userID]);
    await db.close();
    return result;
  }

  Future<int> eliminarAdministrador(int adminID) async {
    final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
    
    final resultCantidad = await db.query(Usuarios.tableName,where:'rol = ?',whereArgs:['A']);

    if(resultCantidad.length == 1){
      await db.close();
      return -1;
    }
    final result = await db.delete(Usuarios.tableName,where:'rol = ? AND id = ?',whereArgs:['A',adminID]);
    
    await db.close();

    return result;
  }

}

final controladorUsuario = _UsuariosControllers();