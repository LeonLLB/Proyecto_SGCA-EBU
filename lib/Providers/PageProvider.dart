import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier{

  String _page = '/home';

  String get page => this._page;

  set page(String newPage){
    this._page=newPage;
    notifyListeners();
  }

}