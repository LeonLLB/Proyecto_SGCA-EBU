Map<String, String> tecMapToPlainMap(Map<dynamic, dynamic> map) =>
    map.map((key, value) =>
        MapEntry(key, (value.runtimeType == String) ? value : value.text));
