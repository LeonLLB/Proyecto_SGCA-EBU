import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/AmbientePicker.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Grado_Seccion.dart';
import 'package:proyecto_sgca_ebu/controllers/MatriculaDocente.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:proyecto_sgca_ebu/models/index.dart';

class AsignarDocente extends StatefulWidget {

  @override
  State<AsignarDocente> createState() => _AsignarDocenteState();
}

class _AsignarDocenteState extends State<AsignarDocente> {  

  final _formKey = GlobalKey<FormState>();

  TextEditingController controlador = TextEditingController();
  
  Future<Usuarios?> docenteSolicitado = controladorUsuario.buscarDocente(null);
  Future<Map<String,Object?>?> matriculaSegunAmbiente = controladorMatriculaDocente.buscarPorGrado(null);
  final Future<List<Ambiente>?> listaAmbientesDisponibles = controladorAmbientes.obtenerGrados();

  bool asignable = false;

  Ambiente? ambiente;
  Usuarios? docente;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * (6/10) - 200;
    return Column(children: [
      Form(
        key: _formKey,
        child: Center(
          child: SimplifiedContainer(            
            width: width,
            child:Row(
              children: [
                SimplifiedTextFormField(
                  controlador: controlador,
                  labelText: 'Cedula del docente',
                  validators: TextFormFieldValidators(required:true,isNumeric:true),  
                ),
              VerticalDivider(),
              TextButton.icon(
                onPressed: (){
                  final future = controladorUsuario.buscarDocente(controlador.text == '' ? null: int.parse(controlador.text));
                  future.then((val){
                    docenteSolicitado = future;
                    if(val == null){
                      asignable = false;
                      docente = null;
                    }else{
                      asignable = true;
                      docente = val;
                    }
                    setState((){});
                  });
                },
                icon: Icon(Icons.search),
                label: Text('Buscar')
              )
            ])
          )
        )
      ),
      Padding(padding:EdgeInsets.symmetric(vertical:5)),
      AmbientePicker(onChange: (ambienteSeleccionado){
        ambiente = ambienteSeleccionado;
        matriculaSegunAmbiente = controladorMatriculaDocente.buscarPorGrado(ambienteSeleccionado!);
        setState((){});
      }),
      Padding(padding:EdgeInsets.symmetric(vertical:5)),
      Row(children: [
        SimplifiedContainer(child: FutureBuilder(
          future: docenteSolicitado,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == null){
              return Center(child: Text('No solicito o no existe el docente'));
            }
            else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Buscando...')
                ]
              ));
            }
            else if(snapshot.hasData && snapshot.data != null){
              return Column(children:[
                Text('${snapshot.data.nombres} ${snapshot.data.apellidos}',
                  style:TextStyle(fontWeight:FontWeight.bold)),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
                Row(children: [
                  Row(children: [
                    Text('C.I: ',style:TextStyle(fontWeight:FontWeight.bold)),
                    Text(snapshot.data.cedula.toString()),
                  ]),
                ],mainAxisAlignment:MainAxisAlignment.spaceBetween),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
                Text((snapshot.data.numero != '') ? snapshot.data.numero : 'Sin teléfono'),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
                Text((snapshot.data.direccion != '') ? snapshot.data.direccion : 'Sin dirección' ,
                  style:TextStyle(fontWeight:FontWeight.bold)),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
                Text((snapshot.data.correo != '') ? snapshot.data.correo : 'Sin correo' ,
                  style:TextStyle(fontWeight:FontWeight.bold)),
              ]);
            }
            else{
              return SizedBox();
            }
          },
        )),

        SimplifiedContainer(child: FutureBuilder(
          future: matriculaSegunAmbiente,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == null){
              return Center(child: Text('No hay una matricula para ese ambiente'));
            }
            else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Buscando...')
                ]
              ));
            }
            else if(snapshot.hasData && snapshot.data != null){
              return Column(children:[
                Text('${snapshot.data['grado']}° \"${snapshot.data['seccion']}\"'),
                Text('${snapshot.data['añoEscolar']}'),
                Text('Estudiantes: ${snapshot.data['NumeroEstudiantes']}'),
                Padding(padding:EdgeInsets.symmetric(vertical:5)),
                Text('Docente Asignado:'),
                Text('${snapshot.data['nombres']} ${snapshot.data['apellidos']}'),
                Text('C.I :${snapshot.data['cedula']}'),
                Text((snapshot.data['numero'] != '') ? snapshot.data['numero'] : 'Sin teléfono'),
                Text((snapshot.data['direccion'] != '') ? snapshot.data['direccion'] : 'Sin dirección' ,
                  style:TextStyle(fontWeight:FontWeight.bold)),
                Text((snapshot.data['correo'] != '') ? snapshot.data['correo'] : 'Sin correo' ,
                  style:TextStyle(fontWeight:FontWeight.bold)),
              ],mainAxisAlignment:MainAxisAlignment.center);
            }
            else{

              return SizedBox();
            }
          },
        ))
      ],mainAxisAlignment:MainAxisAlignment.spaceEvenly),
      Padding(padding:EdgeInsets.symmetric(vertical:5)),
      (asignable) ? ElevatedButton.icon(
        onPressed: ()async{
          final bool? asignacionConfirmada = await confirmarAsignacion(context);

          if(asignacionConfirmada != null && asignacionConfirmada){
            asignarDocente(context);
          }
        },
        icon: Icon(Icons.assignment_ind),
        label: Text('Asignar docente')
      ) : SizedBox(),
    ]);
  }

  Future<bool?> confirmarAsignacion(BuildContext context) async{

    final caso = await controladorMatriculaDocente.casoModificacionMatricula(docente!.cedula,ambiente!);

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar asignación'),
        content: SingleChildScrollView(
          child: Center(
            child:ListBody(children:[
              Text('Asignar a: ${docente!.nombres} ${docente!.apellidos}'),
              Text('Al aula: ${ambiente!.grado}° \"${ambiente!.seccion}\"'),
              Padding(padding:EdgeInsets.symmetric(vertical:10)),
              Row(children:[
                (caso == 1 || caso == 3) ? 
                Icon(Icons.check,color:Colors.green) 
                : Icon(Icons.close,color:Colors.red) ,
                (caso == 1 || caso == 3) ? 
                Text('Aula disponible',style:TextStyle(color:Colors.green)) 
                : Text('Aula asignada',style:TextStyle(color:Colors.red))  ,
              ]),
              Row(children:[
                (caso == 1 || caso == 2) ? 
                Icon(Icons.check,color:Colors.green) 
                : Icon(Icons.close,color:Colors.red) ,
                (caso == 1 || caso == 2) ? 
                Text('Docente disponible',style:TextStyle(color:Colors.green)) 
                : Text('Docente asignado',style:TextStyle(color:Colors.red))  ,
              ]),
              (caso == 1) ? Row(children:[
                Icon(Icons.check,color:Colors.green),
                Text('Se puede asignar sin problemas',style:TextStyle(color:Colors.green))
              ]) : SizedBox(),
              (caso == 2) ? Row(children:[
                Icon(Icons.warning_amber,color:Colors.yellow[700]),
                Text('Al confirmar, se modificara la matricula del aula seleccionada',style:TextStyle(color:Colors.yellow[700]))
              ]) : SizedBox(),
              (caso == 3) ? Row(children:[
                Icon(Icons.warning_amber,color:Colors.yellow[700]),
                Text('Al confirmar, se cambiara la matricula del docente seleccionado',style:TextStyle(color:Colors.yellow[700]))
              ]) : SizedBox(),
              (caso == 4) ? Row(children:[
                Icon(Icons.warning_amber,color:Colors.yellow[700]),
                Text('Al confirmar, se eliminara la matricula del aula, y se cambiara por otra',style:TextStyle(color:Colors.yellow[700]))
              ]) : SizedBox(),
            ]),
          )
        ),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ]
      )
    );
  }

  void asignarDocente(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message:'Asignando docente...',
      onVisible: () async {
        final matriculaDocente = await controladorMatriculaDocente.buscar(docente!.cedula);
        if(matriculaDocente != null && matriculaDocente['grado'] == ambiente!.grado && matriculaDocente['seccion'] == ambiente!.seccion){
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Asignación innecesaria, el docente ya esta asignado a esta aula'));
          return ;
        }
        try {
          final result = await controladorMatriculaDocente.registrar(docente!.cedula, ambiente!);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          if(result > 0){
            ScaffoldMessenger.of(context).showSnackBar(successSnackbar('El docente se asigno con exito'));
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al asignar el docente'));
          }
          matriculaSegunAmbiente = controladorMatriculaDocente.buscarPorGrado(ambiente!);
          setState((){});
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al asignar el docente'));
        }
      }
      )
    );
  }
}