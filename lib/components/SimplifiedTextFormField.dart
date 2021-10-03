import 'package:flutter/material.dart';

class TextFormFieldValidators {
  bool required;
  bool isNumeric;
  bool isNotNumeric;
  int? charLength;
  bool isEmail;
  String? Function(String val)? extraValidator;

  TextFormFieldValidators({
    this.required : false,
    this.isNumeric : false,
    this.isNotNumeric : false,
    this.charLength,
    this.isEmail : false,
    this.extraValidator
  }){
    assert((this.isNumeric == true) && (this.isNotNumeric == true));
  }

}

class SimplifiedTextFormField extends StatelessWidget {

  final TextEditingController controlador;
  final String labelText;
  final Icon? icon;
  final TextFormFieldValidators validators;
  final bool? obscureText;

  SimplifiedTextFormField({
    required this.controlador,
    required this.labelText,
    this.icon,
    required this.validators,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: TextFormField(
      controller: controlador,
      maxLength: validators.charLength,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        icon: icon,
        labelText: labelText,                        
      ),
      validator: (val){
        if (
          validators.required &&
          (val == null || val.isEmpty)
        ) return 'El campo "$labelText" no puede estar vacio';
        else if (
          validators.isNumeric && 
          (val != null && int.tryParse(val) == null) 
        ) return 'El campo "$labelText" solo acepta valores numericos';
        else if (
          validators.isNotNumeric &&
          (val != null && val.contains(RegExp(r'[0-9]')))
        ) return 'El campo "$labelText" no acepta valores numericos';
        else if(
          validators.isEmail && 
          (val != null && (val.contains('@') && val.endsWith('.com')))
        ) return 'El campo "$labelText" no es un correo valido';   
        
        if(validators.extraValidator != null){
          return validators.extraValidator!(val ?? '');
        }
      },
    ));
  }
}