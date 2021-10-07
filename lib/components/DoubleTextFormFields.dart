import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/components/SimplifiedTextFormField.dart';

class DoubleTextFormFields extends StatelessWidget {

  final List<TextEditingController> controladores; 
  final List<Icon?> iconos;
  final List<String> labelTexts;
  final List<TextFormFieldValidators> validators;
  final List<bool>? obscureTexts;

  DoubleTextFormFields({
    required this.controladores,
    required this.iconos,
    required this.labelTexts,
    required this.validators,
    this.obscureTexts : const [false,false]
  }){
    assert(this.controladores.length == 2, "Debe haber 2 controladores solamente, hubieron ${this.controladores.length} controladores");
    assert(this.iconos.length == 0 || this.iconos.length < 3, "Debe haber por lo menos un icono, y un máximo de 2 iconos, hubieron ${this.iconos.length} iconos");
    assert(this.labelTexts.length == 2, "Debe haber 2 descriptores solamente, hubieron ${this.labelTexts.length} descriptores");
    assert(this.validators.length == 2, "Debe haber 2 validadores solamente, hubieron ${this.validators.length} validadores");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        SimplifiedTextFormField(
          controlador: controladores[0],
          labelText: labelTexts[0],
          icon: iconos[0],
          validators: validators[0],
          obscureText: obscureTexts?[0],
        ),
        SimplifiedTextFormField(
          controlador: controladores[1],
          labelText: labelTexts[1],
          icon: iconos.length == 1 ? iconos[0] : iconos[1],
          validators: validators[1],
          obscureText: obscureTexts?[1],
        ), 
      ]
    );
  }
}