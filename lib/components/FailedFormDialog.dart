import 'package:flutter/material.dart';

class FailedFormDialog extends StatelessWidget {
  final String errorTitle;
  final List<Text> descripcion;

  const FailedFormDialog({required this.errorTitle, required this.descripcion});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(errorTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: descripcion,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(width: 4.0, color: Colors.blue[300]!))),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

Future<void> mostrarFalloFormulario(
    String titulo, List<Text> detalles, BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          FailedFormDialog(errorTitle: titulo, descripcion: detalles));
}
