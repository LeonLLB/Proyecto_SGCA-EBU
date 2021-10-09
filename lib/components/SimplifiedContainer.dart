import 'package:flutter/material.dart';

class SimplifiedContainer extends StatelessWidget {

  final Widget child;
  final double? width;
  final double? height;

  SimplifiedContainer({required this.child, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff7C83FD), width: 4),
          borderRadius: BorderRadius.circular(20)
        ),
        child:child,
    );
  }
}