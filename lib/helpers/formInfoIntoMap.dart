import 'package:flutter/material.dart';

Map<String,dynamic> formInfoIntoMap (Map<String, dynamic> info){
  
  Map<String,dynamic> map = {};
  
  for(var input in info.entries){
    if(input.value.runtimeType == TextEditingController){
      map[input.key] = input.value.text;
    }
    else{
      map[input.key] = input.value;
    }
  }

  return map;
}