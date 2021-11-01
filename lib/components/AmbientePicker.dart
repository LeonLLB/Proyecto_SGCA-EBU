import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';

import 'FailedSnackbar.dart';

class AmbientePicker extends StatefulWidget {

  final void Function(Ambiente? ambienteSeleccionado) onChange;

  AmbientePicker({required this.onChange});  

  @override
  State<AmbientePicker> createState() => _AmbientePickerState(onChange:onChange);
}

class _AmbientePickerState extends State<AmbientePicker> {

  final void Function(Ambiente? ambienteSeleccionado) onChange;

  _AmbientePickerState({required this.onChange});  
  final Future<List<Ambiente>?> listaAmbientesDisponibles = controladorAmbientes.obtenerGrados();
  Ambiente? ambiente;

  Future<Ambiente?> getAmbiente (BuildContext context) async{

    final listaDeAmbientes = await listaAmbientesDisponibles;
    if(listaDeAmbientes == null) return null;    

    return await showDialog<Ambiente>(context: context, builder: (_)  =>  SimpleDialog(
      title:Text('Seleccionar el grado y sección'),
      children:listaDeAmbientes.map((ambiente) => 
        SimpleDialogOption(
          onPressed: (){Navigator.pop(_,ambiente);},
          child: Text('${ambiente.grado}° \"${ambiente.seccion}\"')
        )
      ).toList()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()async{        
        if(await listaAmbientesDisponibles == null){
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No hay ambientes inscritos en la base de datos, intentelo más tarde'));
        }
        else{
          final ambienteSeleccionado = await getAmbiente(context);
          if(ambienteSeleccionado != null){
            ambiente = ambienteSeleccionado;
            onChange(ambiente);
            setState((){});
          }
        }

      }, child: Text((ambiente == null) ? 'Seleccionar ambiente' : 'Ambiente seleccionado: ${ambiente!.grado}° \"${ambiente!.seccion}\"')
    );
  }
}