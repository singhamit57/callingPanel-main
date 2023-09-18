import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<String> getcompnamebyid({
  required String compid,
}) async {
  String url = mainurl + '/company/compnamebyid.php';
  String compname = '';
  var body = {
    "GetCompId": compid,
    ...Get.find<LogeduserControll>().logedUserdetailMap(),
  };

  try {
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Status'] == true) {
        compname = data['ResultData'];
      }
    }
  } catch (e) {
    debugPrint('getcompnamebyid :$e');
  }
  return compname;
}
