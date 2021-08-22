void printMap(Map<dynamic, dynamic> map) {
  map.map((key, value) {
    print('$key : $value');
    if (value.runtimeType == Map) {
      printMap(value);
    }
    return MapEntry(key, value);
  });
  return;
}
