import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'components/UI.dart';
import 'pages/Login.dart';
import 'pages/Signup.dart';
import 'providers/AccessProvider.dart';
import 'providers/Pesta%C3%B1aProvider.dart';
import 'providers/SupabaseClient.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PestanaProvider()),
    ChangeNotifierProvider(create: (_) => AccessProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final controladorUsuarios = UsuariosController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGCA-EBU',
      debugShowCheckedModeBanner: false,
      initialRoute:
          (controladorUsuarios.estaAutenticado()) ? '/main' : '/login',
      routes: {
        '/login': (context) => LoginPagina(),
        '/registrar': (context) => SignupPage(),
        '/main': (context) => UIScaffold(),
      },
    );
  }
}
