import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final List<Text> descripcion;
  final void Function() onConfirm;

  const ConfirmDialog({required this.descripcion, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmar'),
      content: SingleChildScrollView(
        child: Center(
          child: ListBody(
            children: descripcion,
          ),
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
            Navigator.of(context).pop('Canceled');
          },
        ),
        TextButton(
          child: Text('Confirmar'),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(width: 4.0, color: Colors.blue[300]!))),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop('Confirm');
          },
        ),
      ],
    );
  }
}

Future<void> mostrarConfirmacionFormulario(List<Text> detalles,
    BuildContext context, void Function() onConfirm) async {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          ConfirmDialog(descripcion: detalles, onConfirm: onConfirm));
}
