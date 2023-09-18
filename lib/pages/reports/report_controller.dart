import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/models/reportcards_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReportPageCtrl extends GetxController {
  var issearching = false.obs;
  var reportcarddetails = ReportCardModel().obs;

  getreportcarddetails() async {
    String _url = mainurl + '/reports/reportcarddetails.php';
    issearching.value = true;
    var body = {
      "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "CompName": Get.find<LogeduserControll>().logeduserdetail.value.compName,
      "UserId": Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      "UserName":
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          reportcarddetails.value =
              ReportCardModel.fromJson(data['ResultData']);
          issearching.value = false;
        } else {
          issearching.value = false;
        }
      } else {
        issearching.value = false;
      }
    } catch (e) {
      issearching.value = false;
      debugPrint('getreportcarddetails :$e');
    }
  }
}

class ReportCardlable {
  static const totalleads = "Total Leads";
  static const availbaleleads = "Available Leads";
  static const dublicateleads = "Duplicate Leads";
  static const usedleads = "Used Leads";
  static const hotleads = "Hot Leads";
  static const mediumleads = "Medium Leads";
  static const coldleads = "Cold Leads";
  static const openleads = "Open Leads";
  static const closedleads = "Closed Leads";
  static const successleads = "Success Leads";
  static const failedleads = "Failed Leads";
  static const totalfollowups = "Total Followups";
  static const todayfollowups = "Today's Followups";
  static const pendingfollowups = "Pending Followups";
  static const totalresponses = "Total Responses";
  static const callhistory = "Call History";
}
