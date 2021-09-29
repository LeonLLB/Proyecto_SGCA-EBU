import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto_sgca_ebu/pages/Login.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(
        "Sistema de Gestión y Control Académico - Escuela Basica Uriapara");
    setWindowMinSize(Size(375, 600));
    setWindowMaxSize(Size(950, 1000));
  }

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
