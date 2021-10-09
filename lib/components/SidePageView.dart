import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/PageProvider.dart';
import 'package:proyecto_sgca_ebu/pages/views/HomeMenu.dart';
import 'package:proyecto_sgca_ebu/routes.dart';

class SidePageView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final String page = Provider.of<PageProvider>(context).page;
    return (page == '/home') ? HomeMenuPage() : routes[page]!;
  }
}