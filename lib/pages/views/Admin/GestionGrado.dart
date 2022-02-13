import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/PageProvider.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/models/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/components/AmbientePicker.dart';
import 'package:proyecto_sgca_ebu/components/Snackbars.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';

enum turnoASeleccionar {e,M,T}

class GestionarGrado extends StatefulWidget {

  @override
  State<GestionarGrado> createState() => _GestionarGradoState();
}

class _GestionarGradoState extends State<GestionarGrado> {

  turnoASeleccionar turnoAmbiente = turnoASeleccionar.e;

  TextEditingController controlador = TextEditingController();
  Future<Ambiente?> ambienteConsultado = controladorAmbientes.obtenerAmbientePorID(null);

  Ambiente? ambiente;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AmbientePicker(onChange: (ambienteSeleccionado){
          ambiente = ambienteSeleccionado;
          if(ambienteSeleccionado!.turno == 'M'){
            turnoAmbiente = turnoASeleccionar.M;
          }else{
            turnoAmbiente = turnoASeleccionar.T;
          }
          ambienteConsultado = controladorAmbientes.obtenerAmbientePorID(ambienteSeleccionado.id!); 
          
          setState((){});
        }),
        Padding(padding:EdgeInsets.symmetric(vertical: 5)),
        FutureBuilder(
          future: ambienteConsultado,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            
            if(snapshot.hasData == false || snapshot.data == null){
              return Center(child: Text('No existe el ambiente seleccionado'));
            }
            else{
              return Column(children: [
                Center(child: Text('Ambiente seleccionado: ${snapshot.data.grado}° "${snapshot.data.seccion}" ')),
                Padding(padding:EdgeInsets.symmetric(vertical: 5)),
                RadioInputRowList<turnoASeleccionar>(
                  groupValue: turnoAmbiente,
                  values: [turnoASeleccionar.e,turnoASeleccionar.M,turnoASeleccionar.T],
                  labels: ['e','Mañana','Tarde'],
                  ignoreFirst:true,
                  onChanged: (val){
                    setState((){
                      turnoAmbiente=val!;
                    });
                  }
                ),
                Padding(padding:EdgeInsets.symmetric(vertical: 5)),
                Row(children:[
                  ElevatedButton(onPressed: (){cambiarTurno(context);}, child: Text('Cambiar turno')),
                  ElevatedButton(onPressed: ()async{
                    final confirmacion = await confirmarEliminacion(context);
                    if(confirmacion != null && confirmacion ){
                      eliminarAmbiente(context);
                    }
                  }, child: Text('Eliminar ambiente'),style:ElevatedButton.styleFrom(primary:Colors.red))
                ])
              ]);
            }
          },
        ),
      ]
    );
  }

  Future<bool?> confirmarEliminacion(BuildContext context)async{
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar eliminacion'),
        content: SingleChildScrollView(
          child: Center(
            child: ListBody(
              children: [
                Icon(Icons.warning,color:Colors.red,size:72),                  
                Wrap(
                  children:[
                  Text('Estas seguro de querer eliminar a este ambiente? No se podra eliminar si esta asignado a una matricula bien sea de docentes o estudiantes',
                    style:TextStyle(color:Colors.red)
                  )
                ])
              ],
            ),
          )
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style:ElevatedButton.styleFrom(primary:Colors.red),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void eliminarAmbiente(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message:'Eliminando aula...',
      onVisible: () async{
        try {
          
          final result = await controladorAmbientes.eliminarAmbiente(ambiente!.id!);

          if(result == -1){
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Existen estudiantes asignados a ese aula, no se puede eliminar!'));
            
          }

          else if(result == -2){
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Existen docentes asignados a ese aula, no se puede eliminar!'));
          }

          else{
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(successSnackbar('El ambiente fue eliminado con exito'));
            Provider.of<PageProvider>(context,listen:false).goBack();
          }
          
        } catch (e) {
          
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
            
          print(e);      
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al cambiar el turno'));
          
        }
      }
    ));
  }

  void cambiarTurno(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message:'Cambiando el turno...',
      onVisible: () async{
        try {
          
          await controladorAmbientes.cambiarTurno(ambiente!.id!,turnoAmbiente.toString().split('.')[1]);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('El turno del aula fue cambiado de manera satisfactoria!'));
        } catch (e) {
          
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
            
          print(e);      
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al cambiar el turno'));
          
          
        }
      }
    ));
  } 
}