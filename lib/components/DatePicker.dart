import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final String label;
  final IconData icono;
  final void Function(String val) onChanged;

  DatePicker(
      {required this.label, required this.icono, required this.onChanged});

  @override
  _DatePickerState createState() =>
      _DatePickerState(label: label, icono: icono, onChanged: onChanged);
}

class _DatePickerState extends State<DatePicker> {
  String label;
  String? date;
  String? fechaAMostrar;
  final IconData icono;
  final void Function(String val) onChanged;
  final TextEditingController controlador = TextEditingController();

  void onTap() {
    datePicker(context).then((fechaSeleccion) {
      if (fechaSeleccion != null) {
        date = fechaSeleccion.toString().split(' ')[0];
        fechaAMostrar = cambiarFecha(date!);
        controlador.text = fechaAMostrar!;
        onChanged(date!);
        setState(() {});
      }
    });
  }

  String cambiarFecha(String unformattedDate) {
    List<String?> nuevaFecha = [null, null, null];
    List<String> split = unformattedDate.split('-');
    nuevaFecha[2] = split[0];
    nuevaFecha[1] = split[1];
    nuevaFecha[0] = split[2];

    return nuevaFecha.join('/');
  }

  _DatePickerState(
      {required this.label, required this.icono, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 4),
          color: Colors.grey[200]),
      child: TextButton(
        onPressed: onTap,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(icono, size: 36, color: Colors.black),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Flexible(
            child: TextFormField(
                controller: controlador,
                decoration: InputDecoration(labelText: label),
                readOnly: true,
                validator: (String? val) {
                  if (val!.isEmpty) {
                    return 'Es obligatorio ingresar la fecha';
                  }
                },
                onTap: onTap),
          )
        ]),
      ),
    );
  }

  Future<DateTime?> datePicker(BuildContext context) async {
    DateTime defaultTime;

    if (date == null) {
      defaultTime = DateTime((DateTime.now().year) - 6);
    } else {
      defaultTime = DateTime(int.parse(date!.split('-')[0]),
          int.parse(date!.split('-')[1]), int.parse(date!.split('-')[2]));
    }

    return await showDatePicker(
        context: context,
        initialDate: defaultTime,
        firstDate: DateTime(2000),
        lastDate: DateTime((DateTime.now().year) - 3),
        helpText: 'Selecciona la fecha de nacimiento',
        cancelText: 'Cancelar',
        confirmText: 'Seleccionar');
  }
}
