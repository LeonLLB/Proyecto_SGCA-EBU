import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/UI.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/providers/AccessProvider.dart';
import 'package:proyecto_sgca_ebu/providers/Pesta%C3%B1aProvider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PestanaProvider()),
    ChangeNotifierProvider(create: (_) => AccessProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SGCA-EBU',
        debugShowCheckedModeBanner: false,
        home: UIScaffold());
  }
}
