import 'package:flutter/material.dart';

class MesPicker extends StatefulWidget {

  final void Function(int? mes) onChange;
  final int? defMes;
  final String? defLabel;

  MesPicker({required this.onChange,this.defLabel,this.defMes});

  @override
  State<MesPicker> createState() => _MesPickerState(onChange:onChange);
}

class _MesPickerState extends State<MesPicker> {

  final void Function(int? mes) onChange;

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
  void initState() {
    super.initState();
    mes = widget.defMes;
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
      }, child: Text((mes == null) ? 'Seleccionar mes' :(widget.defLabel != null)  ? widget.defLabel! + ' ' + mesesDisponibles[mes!-1] :  mesesDisponibles[mes!-1])
    );
  }
}