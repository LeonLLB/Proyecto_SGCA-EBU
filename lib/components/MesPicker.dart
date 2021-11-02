import 'package:flutter/material.dart';

class MesPicker extends StatefulWidget {

  final void Function(int? mesSeleccionado) onChange;

  MesPicker({required this.onChange});

  @override
  State<MesPicker> createState() => _MesPickerState(onChange:onChange);
}

class _MesPickerState extends State<MesPicker> {

  final void Function(int? mesSeleccionado) onChange;

  _MesPickerState({required this.onChange});
  int? mes;

  final List<String> mesesDisponibles = [
    'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre',
    'Octubre','Noviembre','Diciembre'
  ];

  Future<int?> getMes(BuildContext context) async{

    return await showDialog<int>(context: context, builder: (_)=>SimpleDialog(
      title:Text('Seleccionar el mes'),
      children:mesesDisponibles.map((mes) => 
        SimpleDialogOption(
          onPressed: (){Navigator.pop(_,mesesDisponibles.indexWhere((element) => element == mes)+1);},
          child: Text(mes)
        )
      ).toList()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()async{ 
          final mesSeleccionado = await getMes(context);
          if(mesSeleccionado != null){
            mes = mesSeleccionado;
            onChange(mes);
            setState((){});
          }
      }, child: Text((mes == null) ? 'Seleccionar mes' : mesesDisponibles[mes!-1])
    );
  }
}