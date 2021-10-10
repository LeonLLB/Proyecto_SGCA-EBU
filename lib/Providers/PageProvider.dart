import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier{

  String _page = '/home';
  List<Map<String,String>> _history = [{'route':'/home','name':'home'}];

  String get page => this._page;
  List<Map<String,String>> get history => this._history;

  set page(String newPage){
    this._page=newPage;
    notifyListeners();
  }

  set history(List<Map<String,String>> newHistory){
    this._history=newHistory;
    notifyListeners();
  }

  void addToHistory(String newPage,String newRoute){
    this._history.add({'route':newRoute,'name':newPage});
    notifyListeners();
  }

  void substractFromHistory(){
    this._history.removeLast();
    notifyListeners();
  }

}