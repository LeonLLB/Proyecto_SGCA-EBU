import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto_sgca_ebu/Providers/SessionProvider.dart';
import 'package:proyecto_sgca_ebu/pages/Login.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:window_size/window_size.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proyecto_sgca_ebu/models/index.dart';
import 'package:provider/provider.dart';

class _ScrollBehavior extends MaterialScrollBehavior {

  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.mouse,
  };
}

void initTable(String tableInitializer,String testInitializer,db) async{
  try {
    await db.rawQuery(testInitializer);
  } catch (e) {
    if(e.toString().contains('no such table')){
      await db.execute(tableInitializer);
    }
    else{
      throw e;
    }    
  }
}

void initDB() async {

  final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');
  //Usuarios
  initTable(Usuarios.tableInitializer,Usuarios.testInitializer,db);
  initTable(Estudiante.tableInitializer,Estudiante.testInitializer,db);
  initTable(Representante.tableInitializer,Representante.testInitializer,db);
  initTable(EstudianteURepresentante.tableInitializer,EstudianteURepresentante.testInitializer,db);
  initTable(Ambiente.tableInitializer,Ambiente.testInitializer,db);
  initTable(MatriculaEstudiante.tableInitializer,MatriculaEstudiante.testInitializer,db);
  initTable(MatriculaDocente.tableInitializer,MatriculaDocente.testInitializer,db);
  initTable(Admin.tableInitializer,Admin.testInitializer,db);
  initTable(Asistencia.tableInitializer,Asistencia.testInitializer,db);
  initTable(Rendimiento.tableInitializer,Rendimiento.testInitializer,db);
  initTable(Record.tableInitializer,Record.testInitializer,db);
  initTable(FichaEstudiante.tableInitializer,FichaEstudiante.testInitializer,db);

}
void main() {

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(
        "Sistema de Gestión y Control Académico - Escuela Basica Uriapara");
    setWindowMinSize(Size(800, 600));
    setWindowMaxSize(Size(950, 1000));
  }

  sqfliteFfiInit();
  initDB();

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SessionProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior:_ScrollBehavior(),
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
