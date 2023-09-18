import 'dart:convert';

List<String> strtosttlist(String str) =>
    List<String>.from(json.decode(str).map((x) => x));
