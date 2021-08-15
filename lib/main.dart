import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGCA-EBU',
      debugShowCheckedModeBanner: false,
      initialRoute: '/main',
      routes: {
        '/login': (context) => LoginPagina(),
        '/registrar': (context) => SignupPage(),
        '/main': (context) => UIScaffold(),
      },
    );
  }
}
