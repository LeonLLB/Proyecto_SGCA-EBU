import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/MenuContainer.dart';
import 'package:proyecto_sgca_ebu/functions/obtenerMes.dart';

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime formatted = new DateTime(now.year, now.month, now.day);
    final String fecha =
        '${formatted.toString().split(' ')[0].split('-')[2]}/${formatted.toString().split(' ')[0].split('-')[1]}/${formatted.toString().split(' ')[0].split('-')[0]}';

    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        MenuContainer(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fecha),
                Text(
                    'Mes: ${obtenerMes(int.parse(formatted.toString().split(' ')[0].split('-')[1]))}'),
                Text(
                    'Año escolar: ${formatted.toString().split(' ')[0].split('-')[0]}-${int.parse(formatted.toString().split(' ')[0].split('-')[0]) + 1}'),
              ],
            ),
            icon: Icon(Icons.calendar_today))
      ],
    );
  }
}
