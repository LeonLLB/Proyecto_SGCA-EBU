import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/UI.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UI(child: Center(child:Text('Menu home')));
  }
}