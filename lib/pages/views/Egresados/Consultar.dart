import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedContainer.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';
import 'package:proyecto_sgca_ebu/components/Snackbars.dart';
import 'package:proyecto_sgca_ebu/controllers/Egresados.dart';
import 'package:proyecto_sgca_ebu/models/EgresadosRespaldo.dart';
import 'package:proyecto_sgca_ebu/services/PDF.dart';

class EgresadosConsulta extends StatefulWidget {

  @override
  State<EgresadosConsulta> createState() => _EgresadosConsultaState();
}

class _EgresadosConsultaState extends State<EgresadosConsulta> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController mainYear = TextEditingController();
  Future<List<EgresadoRespaldado>?> egresados = controladorEgresados.consultarEgresadosR('');


  @override
  Widget build(BuildContext context) {
    return Expanded(child: SingleChildScrollView(child:Column(children:[
      Form(
        key: _formKey,
        child: SimplifiedContainer(
          width: MediaQuery.of(context).size.width * (9/10) - 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width:150,
                    child: Row(
                      children: [
                        SimplifiedTextFormField(
                          controlador: mainYear,
                          labelText: 'Año',
                          validators: TextFormFieldValidators(
                            onChange:(_){
                              setState((){});
                            },
                            required:true,
                            charLength:4,
                            isNumeric:true,
                            extraValidator: (val){
                              if(val.length != 4){
                                return 'Un año tiene 4 números minimos';
                              }
                            }
                          )
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.minimize),
                  Text('${(mainYear.text != "") ? int.parse(mainYear.text) + 1 : ''}')
                ]
              ),
              Padding(padding:EdgeInsets.symmetric(vertical:5)),
              ElevatedButton(onPressed: (){
                if(_formKey.currentState!.validate()){
                  egresados = controladorEgresados.consultarEgresadosR('${mainYear.text} - ${int.parse(mainYear.text) + 1}');
                  setState((){});
                }
              }, child: Text('Consultar graduandos'))
            ],
          ),
        ),
      ),
      Padding(padding:EdgeInsets.symmetric(vertical:5)),
      FutureBuilder(
        future: egresados,
        builder: (BuildContext context, AsyncSnapshot data) {
          if(data.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(data.data == null){
            return Center(child:Text('No hubo resultados'));
          }else{
            return Column(children:[
              Center(child:Text('Graduandos del año escolar: ${(data.data[0] as EgresadoRespaldado).yearEscolarCursado}',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold))),
              Padding(padding:EdgeInsets.symmetric(vertical:5)),
              Center(child:Text('Fecha de graduación: ${(data.data[0] as EgresadoRespaldado).fechaGraduacion}',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold))),
              Padding(padding:EdgeInsets.symmetric(vertical:5)),
              ElevatedButton(onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                  message:'Generando documento de los egresados...',
                  onVisible: () async {
                    final bool seGenero = await generarDocumentoEgresadosR('${mainYear.text} - ${int.parse(mainYear.text) + 1}');
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    if(seGenero){
                      ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se ha generado correctamente el documento, revise el directorio de descargas'));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo generar el documento'));
                    }
                  }
                  )
                );
              }, child: Text('Generar PDF')),
              Padding(padding:EdgeInsets.symmetric(vertical: 5)),
              Table(
                border: TableBorder(horizontalInside: BorderSide(color:Colors.blue[200]!)),
                children: [
                  TableRow(children: [
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Graduado')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Cedula')),
                      )
                    ),
                    TableCell(child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Representante')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Grado')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Fecha de Nacimiento')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Edad al graduarse')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Generar boletín')),
                      )
                    ),                      
                  ]),
                  ...data.data.map((EgresadoRespaldado egresado)=>TableRow(children: [
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('${egresado.estudiante['nombres']} ${egresado.estudiante['apellidos']}')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('${egresado.estudiante['cedula']}')),
                      )
                    ),
                    TableCell(child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Column(
                          children: [
                            Text('${egresado.representante['nombres']} ${egresado.representante['apellidos']}'),
                            Text('C.I: ${egresado.representante['cedula']}'),
                          ],
                        )),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('${egresado.grado}° "${egresado.seccion}"')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('${egresado.estudiante['fecha_nacimiento']}')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('${egresado.estudiante['edad_al_graduarse']}')),
                      )
                    ),
                    TableCell(
                      child:Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: TextButton.icon(
                          onPressed: ()async{
                            ScaffoldMessenger.of(context).showSnackBar(loadingSnackbar(
                              message:'Generando boletin...',
                              onVisible: () async {
                                final bool seGenero = await generarBoletinR(egresado.id!);
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                if(seGenero){
                                  ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Se ha generado correctamente el boletin, revise el directorio de descargas'));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(failedSnackbar('No se pudo generar el boletin'));
                                }
                              }
                              )
                            );
                          },
                          icon: Icon(Icons.save),
                          label: Text(''))),
                      )
                    ),
                  ])).toList()
                ]
              ),
            ]);
          }
        },
      ),
      Padding(padding:EdgeInsets.symmetric(vertical:5)),
    ])));
  }
}