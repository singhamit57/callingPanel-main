import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/mobileappmodel/callerdetails_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CallerDetailCtrlM extends GetxController {
  var selecteddaterange = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 7),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));

  var userworkdetails = UserWorkReport(
      openCloseLead: [],
      departResponse: [],
      responseCateg: [],
      leadDetail: [],
      successFailLead: []).obs;
  var issearching = false.obs;
  getworkdetails({
    required String compid,
    required String userid,
  }) async {
    issearching.value = true;
    userworkdetails.value = inituserworkdetails;
    var body = {
      "CompId": compid,
      "UserID": userid,
      "FrDate": selecteddaterange.start.toString(),
      "ToDate": selecteddaterange.end.toString(),
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      String _url = mainurl + '/Users/userworkreport_app.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['Status'] == true) {
          userworkdetails.value = UserWorkReport.fromJson(data['ResultData']);
        }
      } else {
        showsnackbar(
            titel: 'Server Error !!!', detail: 'Server not responded...');
      }
    } catch (e) {
      debugPrint("getworkdetails : $e");
    }
    issearching.value = false;
  }
}

var inituserworkdetails = UserWorkReport(
    openCloseLead: [],
    departResponse: [],
    responseCateg: [],
    leadDetail: [],
    successFailLead: []);


/*

{
  "WorkingDays":"8 Days",
  "WorkingHrs":"22 Hrs",
  "WorkingMin":"36 Min",
  "AvgWorking":"6 Hrs",
  "Absents":"3 Absents",
  "Half":"5 Half",
  "ShortLogin":"8 Short",
  "TotalResponses":"252 Responses",
  "DepartResponse":["Properties@@100","Technology@@50"],
  "ResponseCateg":["Properties@@100","Technology@@50"],
  "LeadDetail":["Properties@@100","Technology@@50"],
  "OpenCloseLead":["Properties@@100","Technology@@50"],
  "SuccessFailLead":["Properties@@100","Technology@@50"],
  
}



*/