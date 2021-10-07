import 'package:flutter/material.dart';

SnackBar loadingSnackbar ({required String message,void Function()? onVisible}){
  final double width = message.length * 15;
    return SnackBar(
      onVisible:onVisible,
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
          CircularProgressIndicator(color:Color(0xff96BAFF)),
          Text(message,style:TextStyle(fontSize: 18,color:Colors.black))
        ]
      )
    );
}