import 'package:flutter/material.dart';

Map<String, String> turnInputIntoJson(
        Map<String, TextEditingController> inputData) =>
    inputData.map((llave, valor) => MapEntry(llave, valor.value.text));
