import 'package:flutter/material.dart';

class ContainerInput extends StatelessWidget {
  final String label;
  final TextEditingController controlador;
  final Icon icono;

  ContainerInput(
      {required this.label, required this.controlador, required this.icono});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 4),
          color: Colors.grey[200]),
      child: TextFormField(
        decoration: InputDecoration(icon: this.icono, labelText: this.label),
        controller: this.controlador,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Este campo es requerido.';
          }
        },
      ),
    );
  }
}
