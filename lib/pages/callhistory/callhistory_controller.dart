import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/donload_file.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/leads/leadresponse_model.dart';
import 'package:callingpanel/models/oneleadhistory_model.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter

class CallHistoryWebCtrl extends GetxController {
  var issearching = false.obs;
  // var leadresponsehistory = <LeadResponse>[].obs;
  var responsehistoryshow = <LeadResponse>[].obs;
  var showfullhistoryof = LeadResponse().obs;
  var callloglist = <OneLeadCallLog>[].obs;
  var fromdate = DateTime.now();
  var todate = DateTime.now();
  var isserchingbyinput = '';
  var totalavaildata = 0;
  var totalavailpage = 0;
  var nexpagenumber = 0;
  var previousbody = {};
  openbysidebar() {
    getreponsehistryweb(pagenumber: 0);
  }

  getreponsehistryweb({
    String value = '',
    String? operation,
    String? searchForId,
    required int pagenumber,
    bool isserchingbyinput = false,
  }) async {
    if (pagenumber == 0) {
      issearching.value = true;
      responsehistoryshow.clear();
    }
    var body = {
      'CompId': Get.find<LogeduserControll>().logeduserdetail.value.compId,
      'UserID': Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      'UserName':
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      'FrDate': fromdate.toString(),
      'ToDate': todate.toString(),
      "Isserchingbyinput": isserchingbyinput,
      "SearchInput": value,
      "Operation": operation ?? "",
      "SearchForId": searchForId ?? "",
      "PageNumber": pagenumber,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    if (pagenumber == 0) {
      previousbody = body;
    } else {
      body = {...previousbody, "PageNumber": pagenumber};
    }
    try {
      String _url = mainurl + '/leadresponse/newcallhistory_web.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['Status'] == true) {
          final gotnewdata = List<LeadResponse>.from(
              data['ResultData'].map((x) => LeadResponse.fromJson(x)));
          responsehistoryshow.value = [...responsehistoryshow, ...gotnewdata];
          totalavailpage = data['Msj']['TotalAvlPages'] ?? 0;
          totalavaildata = data['Msj']['TotalAvlData'] ?? 0;
          issearching.value = false;
        } else {
          responsehistoryshow.clear();
          issearching.value = false;
        }
      } else {
        showsnackbar(titel: 'Error !!!', detail: 'Server not responded...');
      }
    } catch (e) {
      debugPrint('getreponsehistryweb : $e');
    }
    issearching.value = false;
    previousbody = body;
    nexpagenumber = pagenumber + 1;
  }

  getcalllogweb() async {
    String _url = mainurl + '/leadresponse/oneleadcallhistory_app.php';
    var _body = {
      'CompID': Get.find<LogeduserControll>().logeduserdetail.value.compId,
      'UserID': Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      'TableId': showfullhistoryof.value.leadId,
      'Mobile': showfullhistoryof.value.mobile,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    issearching.value = true;
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(_body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['Status'] == true) {
          callloglist.value = List<OneLeadCallLog>.from(
              data['ResultData'].map((x) => OneLeadCallLog.fromJson(x)));
          issearching.value = false;
        } else {
          issearching.value = false;
        }
      }
    } catch (e) {
      debugPrint('getcalllogweb : $e');

      issearching.value = false;
    }
  }

  downloadFile() async {
    String _url = mainurl + '/leadresponse/callhistory_app.php';
    var body = {...previousbody, "operation": "download"};
    if (issearching.value) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please wait...');
      return;
    }
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var filepath = data['Msj'];
        if (data['Status'] == true && filepath.toString().contains('http')) {
          downloadFileByUrl(url: filepath);
        } else {
          showsnackbar(
              titel: 'Failed !!!', detail: 'Unable to generate report....');
        }
      } else {
        showsnackbar(titel: 'Failed !!!', detail: 'Server not respond....');
      }
    } catch (e) {
      debugPrint("downloadFile : $e");
      showsnackbar(titel: 'Failed !!!', detail: 'Something is wrong....');
    }
  }
}
