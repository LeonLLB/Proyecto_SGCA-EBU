import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/MenuContainer.dart';
import 'package:proyecto_sgca_ebu/functions/obtenerMes.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/providers/AccessProvider.dart';

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: (context.watch<AccessProvider>().rol == 'admin')
          ? menuSwap(context, 1)
          : menuSwap(context, 2),
    );
  }

  List<Widget> menuSwap(BuildContext context, int version) {
    final DateTime now = DateTime.now();
    final DateTime formatted = new DateTime(now.year, now.month, now.day);
    final String fecha =
        '${formatted.toString().split(' ')[0].split('-')[2]}/${formatted.toString().split(' ')[0].split('-')[1]}/${formatted.toString().split(' ')[0].split('-')[0]}';

    final TextStyle normalText = TextStyle(fontSize: 20);
    final TextStyle boldText =
        TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    if (version == 1 /* Admin */) {
      return [
        MenuContainer(
            body: [
              Text(fecha, style: normalText),
              Row(children: [
                Text('Mes: ', style: normalText),
                Text(
                    obtenerMes(int.parse(
                        formatted.toString().split(' ')[0].split('-')[1])),
                    style: boldText)
              ]),
              Row(children: [
                Text('Año Escolar: ', style: normalText),
                Text(
                    '${formatted.toString().split(' ')[0].split('-')[0]}-${int.parse(formatted.toString().split(' ')[0].split('-')[0]) + 1}',
                    style: boldText)
              ]),
            ],
            icon: Icon(Icons.calendar_today, size: 60),
            alignment: CrossAxisAlignment.start),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        MenuContainer(body: [
          Text('Estudiantes Activos:', style: normalText),
          Text('710', style: boldText),
        ], icon: Icon(Icons.face, size: 60)),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        MenuContainer(body: [
          Text('Docentes Activos:', style: normalText),
          Text('30', style: boldText)
        ], icon: Icon(Icons.assignment_ind, size: 60)),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        MenuContainer(body: [
          Text(
            'Usuarios pendientes de registro:',
            style: normalText,
            textAlign: TextAlign.center,
          ),
          Text('0', style: boldText)
        ], icon: Icon(Icons.accessibility, size: 60)),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Align(
          child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Cerrando sesión')));
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Cerrar sesión', style: normalText),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(width: 4.0, color: Colors.blue[300]!)))),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 12.5))
      ];
    } else /*Docente*/ {
      return [
        MenuContainer(
            body: [
              Text(fecha, style: normalText),
              Row(children: [
                Text('Mes: ', style: normalText),
                Text(
                    obtenerMes(int.parse(
                        formatted.toString().split(' ')[0].split('-')[1])),
                    style: boldText)
              ]),
              Row(children: [
                Text('Año Escolar: ', style: normalText),
                Text(
                    '${formatted.toString().split(' ')[0].split('-')[0]}-${int.parse(formatted.toString().split(' ')[0].split('-')[0]) + 1}',
                    style: boldText)
              ]),
            ],
            icon: Icon(Icons.calendar_today, size: 60),
            alignment: CrossAxisAlignment.start),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        MenuContainer(body: [
          Text('Grado Asignado:', style: normalText),
          Text('4to "A"', style: boldText)
        ], icon: Icon(Icons.assignment_ind, size: 60)),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        MenuContainer(body: [
          Text('Estudiantes del Grado Asignado:',
              style: normalText, textAlign: TextAlign.center),
          Text('28', style: boldText),
        ], icon: Icon(Icons.face, size: 60)),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Align(
          child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Cerrando sesión')));
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Cerrar sesión', style: normalText),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(width: 4.0, color: Colors.blue[300]!)))),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 12.5))
      ];
    }
  }
}
