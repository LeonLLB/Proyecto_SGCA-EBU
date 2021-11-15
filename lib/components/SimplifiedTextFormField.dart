import 'package:flutter/material.dart';

class TextFormFieldValidators {
  bool required;
  bool isNumeric;
  bool isDouble;
  bool isNotNumeric;
  int? charLength;
  bool isEmail;
  String? Function(String val)? extraValidator;
  void Function(String)? onChange;

  TextFormFieldValidators({
    this.required : false,
    this.isNumeric : false,
    this.isNotNumeric : false,
    this.charLength,
    this.isEmail : false,
    this.extraValidator,
    this.onChange,
    this.isDouble: false
  }){
    assert(!(this.isNumeric && this.isNotNumeric));
  }

}

class SimplifiedTextFormField extends StatelessWidget {

  final TextEditingController controlador;
  final String labelText;
  final Icon? icon;
  final TextFormFieldValidators validators;
  final bool? obscureText;
  final String? helperText;
  final bool? enabled;

  SimplifiedTextFormField({
    required this.controlador,
    required this.labelText,
    this.icon,
    required this.validators,
    this.obscureText,
    this.helperText,
    this.enabled
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: TextFormField(
      controller: controlador,
      maxLength: validators.charLength,
      obscureText: obscureText ?? false,
      onChanged: validators.onChange,
      enabled:enabled,
      decoration: InputDecoration(
        icon: icon,
        labelText: labelText,
        helperText:  helperText                       
      ),
      validator: (val){
        if (
          validators.required &&
          (val == null || val.isEmpty)
        ) return 'El campo "$labelText" no puede estar vacio';
        else if (
          validators.isNumeric && 
          (val!.isNotEmpty && int.tryParse(val) == null) 
        ) return 'El campo "$labelText" solo acepta valores numericos';
        else if (
          validators.isNotNumeric &&
          (val!.isNotEmpty && val.contains(RegExp(r'[0-9]')))
        ) return 'El campo "$labelText" no acepta valores numericos';
        else if(
          validators.isEmail && 
          (val!.isNotEmpty && (!val.contains('@') && !val.endsWith('.com')))
        ) return 'El campo "$labelText" no es un correo valido';   
        else if(
          validators.isDouble &&
          (val!.isNotEmpty && double.tryParse(val) == null)
        )return 'El campo "$labelText" no es un numero valido';
        if(validators.extraValidator != null){
          return validators.extraValidator!(val ?? '');
        }
      },
    ));
  }
}