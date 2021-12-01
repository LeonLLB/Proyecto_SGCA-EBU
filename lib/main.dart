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

Future<void> initTable(String tableInitializer,String testInitializer) async{
  final db = await databaseFactoryFfi.openDatabase('sgca-ebu-database.db');

  try {
    await db.rawQuery(testInitializer);
  } catch (e) {
    if(e.toString().contains('no such table')){
      await db.execute(tableInitializer);
    }
    else{
      print(e);
      throw e;
    }  
  }

  await db.close();
}

void initDB() async {
  
  //Usuarios
  await initTable(Usuarios.tableInitializer,Usuarios.testInitializer);
  await initTable(Estudiante.tableInitializer,Estudiante.testInitializer);
  await initTable(Representante.tableInitializer,Representante.testInitializer);
  await initTable(EstudianteURepresentante.tableInitializer,EstudianteURepresentante.testInitializer);
  await initTable(Ambiente.tableInitializer,Ambiente.testInitializer);
  await initTable(MatriculaEstudiante.tableInitializer,MatriculaEstudiante.testInitializer);
  await initTable(MatriculaDocente.tableInitializer,MatriculaDocente.testInitializer);
  await initTable(Admin.tableInitializer,Admin.testInitializer);
  await initTable(Asistencia.tableInitializer,Asistencia.testInitializer);
  await initTable(Rendimiento.tableInitializer,Rendimiento.testInitializer);
  await initTable(Record.tableInitializer,Record.testInitializer);
  await initTable(FichaEstudiante.tableInitializer,FichaEstudiante.testInitializer);
  await initTable(RecordFicha.tableInitializer,RecordFicha.testInitializer);
  await initTable(Estadistica.tableInitializer,Estadistica.testInitializer);
  await initTable(Egresado.tableInitializer,Egresado.testInitializer);

}
void main() {

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(
        "Sistema de Gestión y Control Académico - Escuela Basica Uriapara");
    setWindowMinSize(Size(950, 600));
    setWindowMaxSize(Size(950, 600));
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
