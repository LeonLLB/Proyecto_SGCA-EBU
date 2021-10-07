import 'package:flutter/material.dart';

SnackBar failedSnackbar (String message){
  final double width = message.length * 15;
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
          Icon(Icons.cancel,color:Colors.red,size:28),
          Text(message,style:TextStyle(fontSize: 18,color:Colors.black))
        ]
      )
    );
}
    