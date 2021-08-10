import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PestanaProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _pageNumber = 0;
  int _zona =
      0; // 0 PRINCIPAL 1 ESTUDIANTES 2 DOCENTES 4 REPRESENTANTES 3 EGRESADOS
  String _appBarText = 'SGCA-EBU';

  int get pestanaID => _pageNumber;
  int get zonaID => _zona;
  String get textoDelAppBar => _appBarText;

  void cambiarPagina(
      {int zona: -1, int numPage: -1, String appBarText: 'SGCA-EBU'}) {
    if (zona >= 0 && zona <= 4) {
      this._zona = zona;
    }
    if (numPage >= 0) {
      this._pageNumber = numPage;
    }
    this._appBarText = appBarText;
    notifyListeners();
  }
}
