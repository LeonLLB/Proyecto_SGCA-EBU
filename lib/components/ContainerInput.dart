import 'package:flutter/material.dart';

class ContainerInput extends StatelessWidget {
  final String label;
  final TextEditingController controlador;
  final Icon icono;
  final bool unEditable;
  final Map<String, bool> validators;
  final void Function(String val)? afterMathChanged;

  ContainerInput(
      {required this.label,
      required this.controlador,
      required this.icono,
      this.unEditable: false,
      this.afterMathChanged,
      this.validators: const {
        'required': true,
        'numeric': false,
      }});

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
        readOnly: unEditable,
        decoration: InputDecoration(icon: this.icono, labelText: this.label),
        controller: this.controlador,
        keyboardType:
            (validators['numeric']!) ? TextInputType.phone : TextInputType.text,
        onChanged: (val) {
          afterMathChanged!(val);
        },
        validator: (val) {
          if (val == null || val.isEmpty && validators['required']!) {
            return 'Este campo es requerido.';
          }
          if (val.isNotEmpty && validators['numeric']!) {
            return 'Ingrese solo números';
          }
        },
      ),
    );
  }
}
