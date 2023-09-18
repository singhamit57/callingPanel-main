import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/date_format.dart';
import 'package:callingpanel/models/mobileappmodel/callerdetails_model.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CallerWorkReportWebCtrl extends GetxService {
  var issearching = false.obs;
  var gotreportdata = blankreportdata.obs;
  var selectedchip = "".obs;
  var customrangereport = "".obs;
  String compid = '';
  String userid = '';
  DateTime fromdate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 7);
  DateTime todate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  ondaterangechange({
    required DateTime setfromdate,
    required DateTime settodate,
  }) {
    fromdate = setfromdate;
    todate = settodate;
    selectedchip.value = "";
    customrangereport.value = "";
    final showfrdate = date_dM(setfromdate);
    final showtodate = date_dM(settodate);
    customrangereport.value = "$showfrdate - $showtodate";
    selectedchip.value = "$showfrdate - $showtodate";
    getworkdetails(operation: "adminbydaterange");
  }

  getworkdetails({
    String? operation,
  }) async {
    issearching.value = true;
    var body = {
      "CompId": compid,
      "UserID": userid,
      "CallFrom": "admin",
      "Operation": (operation ?? "")
          .toLowerCase()
          .replaceAll(" ", "")
          .replaceAll("'", ""),
      "FrDate": fromdate.toString(),
      "ToDate": todate.toString(),
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      String _url = mainurl + '/Users/userworkreport_app.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['Status'] == true) {
          gotreportdata.value = UserWorkReport.fromJson(data['ResultData']);
        }
      }
    } catch (e) {
      debugPrint("getworkdetailsweb : $e");
    }
    issearching.value = false;
  }
}

UserWorkReport blankreportdata = UserWorkReport(
    workingDays: '0',
    openCloseLead: [],
    departResponse: [],
    responseCateg: [],
    leadDetail: [],
    successFailLead: []);
