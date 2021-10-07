import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto_sgca_ebu/pages/Login.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:window_size/window_size.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/index.dart';

void initDB() async {

  final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
  //Usuarios
  try {
    await db.rawQuery(Usuarios.testInitializer);
  } catch (e) {
    if(e.toString().contains('no such table')){
      await db.execute(Usuarios.tableInitializer);
    }
    else{
      throw e;
    }    
  }
  

}
void main() {

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(
        "Sistema de Gestión y Control Académico - Escuela Basica Uriapara");
    setWindowMinSize(Size(375, 600));
    setWindowMaxSize(Size(950, 1000));
  }

  sqfliteFfiInit();
  initDB();

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SGCA - EBU',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('es', 'VE')],
      home: LoginPage()
    );
  }
}
