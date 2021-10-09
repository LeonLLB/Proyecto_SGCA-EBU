import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_sgca_ebu/models/Usuarios.dart';

class SessionProvider extends ChangeNotifier{
  bool _logged = false;
  Usuarios? _user;

  bool get isLogged => this._logged;
  Usuarios get usuario => this._user!;

  set isLogged(bool status){
    this._logged = status;
    notifyListeners();
  }

  set usuario(Usuarios? usuario){
    this._user = usuario;
    notifyListeners();
  }

}