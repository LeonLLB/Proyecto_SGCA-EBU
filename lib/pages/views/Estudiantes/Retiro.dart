import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/Snackbars.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';

class RetiroEstudiante extends StatefulWidget {

  @override
  _RetiroEstudianteState createState() => _RetiroEstudianteState();
}

class _RetiroEstudianteState extends State<RetiroEstudiante> {

  TextEditingController controladorConsulta = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<Map<String,Object?>?> estudianteSolicitado = controladorEstudiante.buscarEstudiante(null);

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width * (6/10) - 200;

    return Column(
      children:[
        Form(
          key:_formKey,
          child:Center(
            child: SimplifiedContainer(            
              width: width,
              child:Row(
                children: [
                  SimplifiedTextFormField(
                    controlador: controladorConsulta,
                    labelText: 'Cedula escolar',
                    validators: TextFormFieldValidators(required:true,isNumeric:true),  
                  ),
                VerticalDivider(),
                TextButton.icon(
                  onPressed: (){
                    final future = controladorEstudiante.buscarEstudiante(controladorConsulta.text == '' ? null: int.parse(controladorConsulta.text));
                    future.then((val){
                      estudianteSolicitado = future;
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
        FutureBuilder(
          future: estudianteSolicitado,
          builder: (BuildContext context, AsyncSnapshot data) {
            if(data.data == null){
              return SimplifiedContainer(
                width:width,
                child: Center(
                  child:Text('No existe el estudiante')
                )
              );
            }
            else if(data.connectionState == ConnectionState.waiting){
              return SimplifiedContainer(
                width:width,
                child: Center(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text('Buscando...')
                    ]
                )),
              );
            }
            else{
              return Column(
                children:[
                  SimplifiedContainer(
                    width:width,
                    child: Column(
                      children: [
                        Text('${data.data["estudiante.nombres"]} ${data.data["estudiante.apellidos"]}',
                        style:TextStyle(fontWeight:FontWeight.bold)),
                        Row(children: [
                          Row(children: [
                            Text('C.E: ',style:TextStyle(fontWeight:FontWeight.bold)),
                            SelectableText(data.data['estudiante.cedula'].toString()),
                          ]),
                        Text(calcularEdad(data.data["estudiante.fecha_nacimiento"]).toString() + ' años')
                        ],mainAxisAlignment:MainAxisAlignment.spaceBetween),
                        Row(children: [
                          Text(data.data['añoEscolar']),
                          Text(data.data['grado'].toString() + '° "${data.data['seccion']}"')
                        ],mainAxisAlignment:MainAxisAlignment.spaceBetween),
                        Text('${data.data["representante.nombres"]} ${data.data["representante.apellidos"]}',
                          style:TextStyle(fontWeight:FontWeight.bold)),
                        Row(children: [
                          Text('C.I: ',style:TextStyle(fontWeight:FontWeight.bold)),
                          SelectableText(data.data['representante.cedula'].toString()),
                        ]),                        
                      ]
                    )
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical:5)),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children:[
                      ElevatedButton(onPressed: (){}, child: Text('Generar boletín')),
                      ElevatedButton(onPressed: (){}, child: Text('Generar record de ficha'))
                    ]
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical:5)),
                  ElevatedButton(
                    style:ElevatedButton.styleFrom(primary:Colors.red),
                    onPressed: ()async{
                      final confirmacion = await confirmarEliminacion(context);
                        if(confirmacion != null && confirmacion){
                          try {
                            await controladorEstudiante.eliminarEstudiante(data.data['estudiante.id']);
                            ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Estudiante retirado con exito'));
                            estudianteSolicitado = controladorEstudiante.buscarEstudiante(null);
                            controladorConsulta.text = '';
                            setState((){});
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Hubo un error al retirar al estudiante'));
                          }
                        }
                    },
                    child: Text('Retirar estudiante')
                  )
                ]
              );
            }
          },
        ),        
      ]
    );
  }

  Future<bool?> confirmarEliminacion(
    BuildContext context
  )async{
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar retiro'),
        content: SingleChildScrollView(
          child: Center(
            child: ListBody(
              children: [
                Icon(Icons.warning,color:Colors.red,size:72),                  
                Wrap(
                  children:[
                  Text('Estas seguro de querer retirar a este estudiante? Toda información que tenga que ver con el mismo sera eliminada de manera permanente, se recomienda respaldar su boletín u otros datos primero',
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
}