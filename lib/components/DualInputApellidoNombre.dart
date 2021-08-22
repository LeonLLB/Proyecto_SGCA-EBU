import 'package:flutter/material.dart';

class DualInputApellidosNombres extends StatelessWidget {
  final TextEditingController apellidoControlador;
  final TextEditingController nombreControlador;
  final String labelRest;
  final IconData icono;
  final bool unEditable;

  DualInputApellidosNombres(
      {required this.apellidoControlador,
      required this.nombreControlador,
      required this.labelRest,
      required this.icono,
      this.unEditable: false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 4),
          color: Colors.grey[200]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icono, size: 60),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  readOnly: unEditable,
                  decoration: InputDecoration(
                      labelText: 'Nombres del ${this.labelRest}'),
                  controller: this.nombreControlador,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Este campo es requerido.';
                    }
                  },
                ),
                TextFormField(
                  readOnly: unEditable,
                  decoration: InputDecoration(
                      labelText: 'Apellidos del ${this.labelRest}'),
                  controller: this.apellidoControlador,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Este campo es requerido.';
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
