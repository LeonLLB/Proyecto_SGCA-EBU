import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/FailedSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/RadioInputsRowList.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/controllers/Estudiante.dart';
import 'package:proyecto_sgca_ebu/controllers/Usuarios.dart';
import 'package:proyecto_sgca_ebu/helpers/calcularEdad.dart';
import 'package:proyecto_sgca_ebu/services/PDF.dart';

enum _genero {F, M}

class EstudianteGenerarConstancia extends StatefulWidget {

  @override
  _EstudianteGenerarConstanciaState createState() => _EstudianteGenerarConstanciaState();
}

class _EstudianteGenerarConstanciaState extends State<EstudianteGenerarConstancia> {

  _genero generoDirector = _genero.F;

  final _formKey = GlobalKey<FormState>();

  TextEditingController controlador = TextEditingController();  
  TextEditingController controladorDirector = TextEditingController();  

  Future<Map<String,Object?>?> estudianteSolicitado = controladorEstudiante.buscarEstudiante(null);

  bool hayEstudiante = false;

  Map<String,Object?>? estudiante;

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
                  labelText: 'Cedula escolar',
                  validators: TextFormFieldValidators(required:true,isNumeric:true),  
                ),
              VerticalDivider(),
              TextButton.icon(
                onPressed: (){
                  final future = controladorEstudiante.buscarEstudiante(controlador.text == '' ? null: int.parse(controlador.text));
                  future.then((val){
                    estudianteSolicitado = future;
                    if(val == null){
                      hayEstudiante = false;
                      estudiante = null;
                    }else{
                      hayEstudiante = true;
                      estudiante = val;
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
      SimplifiedContainer(
        width:width,
        child: FutureBuilder(
          future: estudianteSolicitado,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == null){
              return Center(child:Text('No existe el estudiante'));
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
                Text('${snapshot.data["estudiante.nombres"]} ${snapshot.data["estudiante.apellidos"]}',
                  style:TextStyle(fontWeight:FontWeight.bold)),
                Row(children: [
                  Row(children: [
                    Text('C.E: ',style:TextStyle(fontWeight:FontWeight.bold)),
                    Text(snapshot.data['estudiante.cedula'].toString()),
                  ]),
                  Text(calcularEdad(snapshot.data["estudiante.fecha_nacimiento"]).toString() + ' años')
                ],mainAxisAlignment:MainAxisAlignment.spaceBetween),
                Row(children: [
                  Text(snapshot.data['añoEscolar']),
                  Text(snapshot.data['grado'].toString() + '"${snapshot.data['seccion']}"')
                ],mainAxisAlignment:MainAxisAlignment.spaceBetween),
                Text('${snapshot.data["representante.nombres"]} ${snapshot.data["representante.apellidos"]}',
                  style:TextStyle(fontWeight:FontWeight.bold)),
                Row(children: [
                  Text('C.I: ',style:TextStyle(fontWeight:FontWeight.bold)),
                  Text(snapshot.data['representante.cedula'].toString()),
                ]),
              ]);
            }
            else{
              hayEstudiante = false;
              setState((){});
              return SizedBox();
            }
          },
        ),
      ),
      Padding(padding:EdgeInsets.symmetric(vertical:5)),
      (hayEstudiante) 
      ? Center(
        child: Column(        
          children: [
            SimplifiedContainer(
              width: width,
              child: Row(
                children: [
                  SimplifiedTextFormField(
                    controlador: controladorDirector,
                    labelText: 'Cedula director',
                    validators: TextFormFieldValidators(required:true,isNumeric:true), 
                  ),
                ],
              ),
            ),
            RadioInputRowList<_genero>(
              groupValue: generoDirector,
              values: [_genero.F,_genero.M],
              labels: ['Directora','Director'],
              onChanged: (val){
                setState(() {
                  generoDirector = val!;
                });
              }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(onPressed: (){generarConstancia(context);}, icon: Icon(Icons.save), label: Text('Guardar constancia')),
                ElevatedButton.icon(onPressed: (){imprimirConstancia(context);}, icon: Icon(Icons.print), label: Text('Imprimir constancia'))
              ]
            ),
            
          ]
        ),
      ) : SizedBox()
    ]);
  }

  void generarConstancia(BuildContext context) {
    if(controladorDirector.text == ''){
      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Es necesario la cedula del director'));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message:'Generando constancia...',
      onVisible: () async {
        final director = await controladorUsuario.buscarAdmin(int.parse(controladorDirector.text));
        if(director == null){
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Es necesario la cedula del director'));
          return;
        }
        final bool seGenero = await generarConstanciaEstudianteCompleta(estudiante!,director,generoDirector.toString().split('.')[1]);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        if(seGenero){
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se ha generado correctamente la constancia de estudio, revise el directorio de descargas'));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo generar la constancia de estudio'));
        }
      }
      )
    );
  }

  void imprimirConstancia(BuildContext context) {
    if(controladorDirector.text == ''){
      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Es necesario la cedula del director'));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
      message:'Imprimiendo constancia...',
      onVisible: () async {
        final director = await controladorUsuario.buscarAdmin(int.parse(controladorDirector.text));
        if(director == null){
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('Es necesario la cedula del director'));
          return;
        }
        final bool seGenero = await imprimirConstanciaEstudianteCompleta(estudiante!,director,generoDirector.toString().split('.')[1]);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        if(seGenero){
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Constancia impresa con exito'));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo imprimir la constancia de estudio'));
        }
      }
      )
    );
  }
}