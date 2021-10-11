import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/PageProvider.dart';

class SubMenuItem extends StatelessWidget {

  final IconData icon;
  final String label;
  final String route;

  SubMenuItem({
    required this.icon,
    required this.label,
    required this.route
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:155,
      height:155,
      margin:EdgeInsets.symmetric(vertical:5),
      child: Column(
        children: [
          Container(
            width:100,
            height:100,
            child: TextButton(
              onPressed:(){
                
                Provider.of<PageProvider>(context,listen:false).page = route; 

                Provider.of<PageProvider>(context,listen:false).addToHistory(label,route);
               
              },
              child: CustomPaint(
                painter:_SubMenuItemContainer(),
                child:Center(
                  child:Icon(icon,color:Colors.white,size:48)
                )
              ),
            ),
          ),
          Padding(padding:EdgeInsets.only(bottom:5)),
          Container(
            child: Text(label)
          ),
        ],
      )
    );
  }
}

class _SubMenuItemContainer extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final pencilBorder = Paint()
      ..color = Color(0xff88FFF7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final pencilFill = Paint()
      ..color = Color(0xff96BAFF)
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;
    
    final path = Path()
    ..moveTo(size.width * 1/4,0)
    ..lineTo(0, size.height * 1/2)
    ..lineTo(size.width * 1/4, size.height)
    ..lineTo(size.width * 3/4, size.height)
    ..lineTo(size.width, size.height * 1/2)
    ..lineTo(size.width * 3/4, 0)
    ..lineTo(size.width * 1/4,0);

    canvas.drawPath(path, pencilFill);
    canvas.drawPath(path, pencilBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}