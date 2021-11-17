import 'package:flutter/material.dart';

SnackBar simpleSnackbar (String message){
  final double width = message.length * 10;
    return SnackBar(
      width:width,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color:Color(0xff96BAFF)
        ),
        borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      behavior:SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Text(message,style:TextStyle(fontSize: 18,color:Colors.black))
        ]
      )
    );
}
    