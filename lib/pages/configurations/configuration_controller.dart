import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ConfigurationPageCtrl extends GetxController {
  var issearching = false.obs;

  deleteResponseDepartment({
    required String lable,
    required String operation,
  }) async {
    String _url = mainurl + '/configuration/deleteResponseDepartment.php';
    issearching.value = true;
    var body = {
      "CompanyID": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "CompanyName":
          Get.find<LogeduserControll>().logeduserdetail.value.compName,
      "LogedUserId":
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      "LogedUserName":
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      "Deletefor": operation,
      "lablename": lable,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          showsnackbar(
              titel: 'Success', detail: 'Response deleted sucessfully...');
          if (operation == 'Department') {
            await Get.find<LogeduserControll>().getcompdeparts();
          }
          if (operation == 'Response') {
            await Get.find<LogeduserControll>().getcompresponse();
          }

          issearching.value = false;
        } else {
          showsnackbar(titel: 'Failed', detail: 'Failed to delete response...');
          issearching.value = false;
        }
      } else {
        showsnackbar(titel: 'Failed', detail: 'Something is wrong...');
        issearching.value = false;
      }
    } catch (e) {
      showsnackbar(titel: 'Failed', detail: 'Something is wrong...');
      issearching.value = false;
      debugPrint('deleteResponseDepartment :$e');
    }
  }
}
