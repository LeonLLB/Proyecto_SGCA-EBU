import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_sgca_ebu/Providers/PageProvider.dart';
import 'package:proyecto_sgca_ebu/Providers/SessionProvider.dart';
import 'package:proyecto_sgca_ebu/components/CustomSideBarItem.dart';
import 'package:proyecto_sgca_ebu/components/PageBreadCumbs.dart';
import 'package:proyecto_sgca_ebu/components/SidePageView.dart';
import 'package:proyecto_sgca_ebu/components/SuccesSnackbar.dart';
import 'package:proyecto_sgca_ebu/components/UI.dart';
import 'package:proyecto_sgca_ebu/components/loadingSnackbar.dart';
import 'package:proyecto_sgca_ebu/routes.dart';

class HomeMenu extends StatelessWidget {

  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageProvider() ,
      child: UI(
        child: Row(
          children: [
            Container(
              padding:EdgeInsets.only(top:10),
              width: 200,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color:Colors.grey,width:2)),/* (color: Color(0xff7C83FD), width: 4) */
              ),
              child:ListView(controller:controller,children: [
                CustomSideBarItem(icon: Icons.home, label: 'Principal', route: '/home'),
                CustomSideBarItem(icon: Icons.face, label: 'Estudiantes', route: '-estudiantes'),
                CustomSideBarItem(icon: Icons.assignment_ind, label: 'Docentes', route: '-docentes'),
                CustomSideBarItem(icon: Icons.supervisor_account, label: 'Representantes', route: '-representantes'),
                CustomSideBarItem(icon: Icons.school, label: 'Egresados', route: '-egresados'),
                CustomSideBarItem(icon: Icons.settings, label: 'Administrativo y configuración', route: '-admin'),
                ListTile(
                  leading:Icon(Icons.vpn_key,color:Colors.black),
                  title:Text('Cerrar sesión',style:TextStyle(color: Colors.black)),onTap:(){

                    ScaffoldMessenger.of(context).showSnackBar(
                      loadingSnackbar(
                        message: 'Cerrando sesión...',
                        onVisible:(){
                          Provider.of<SessionProvider>(context,listen:false).isLogged = false;
                          Provider.of<SessionProvider>(context,listen:false).usuario = null;
                          Navigator.pushReplacement(context, toPage('/login'));
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Sesión cerrada con exito!'));
                        }
                        )
                      );
                })
              ])
            ),
            Expanded(child: 
              Container(
                padding: EdgeInsets.symmetric(horizontal:25),
                height: double.infinity,
                child:Column(
                  children: [
                    PageBreadCumbs(),
                    Padding(padding:EdgeInsets.symmetric(vertical:5)),
                    SidePageView(),
                  ],
                )
              ),
            )
          ],
        )
        ),
    );
  }
}