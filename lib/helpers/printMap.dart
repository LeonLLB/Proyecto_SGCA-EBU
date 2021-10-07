void printMap (Map<dynamic,dynamic> map){

  for (var item in map.entries) {
    if(item.value.runtimeType == Map){
      printMap(item.value);
    }
    else{
      print('${item.key} : ${item.value}');
    }
  }

}