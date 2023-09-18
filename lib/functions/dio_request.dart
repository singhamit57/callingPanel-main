import 'package:callingpanel/constants/connection_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

builhead() {
  return {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials":
        true, // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS"
  };
}

Future<String?> makehttppost({
  required String path,
  required String functionname,
  var data,
}) async {
  String fullurl = mainurl + path;
  try {
    http.Response response = await http
        .post(Uri.parse(fullurl), body: data)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      return response.body;
    }
  } catch (e) {
    debugPrint('$functionname :$e');
    return null;
  }
  return null;
}
