import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/models/leads/leadresponse_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CallHistoryCtrl extends GetxService {
  @override
  void onReady() {
    ditictresponse();
    super.onReady();
  }

  var leadresponsehistory = <LeadResponse>[].obs;
  var responsehistoryshow = <LeadResponse>[].obs;
  var searchtextctrl = TextEditingController();
  var distinctresponse = <String>[];
  var selectedaterange = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 7),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
  var issearching = false.obs;
  getreponsehistry() async {
    issearching.value = true;
    leadresponsehistory.clear();
    searchtextctrl.text = '';
    var body = {
      'CompId': Get.find<LogeduserControll>().logeduserdetail.value.compId,
      'UserID': Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      'UserName':
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      'FrDate': selectedaterange.start.toString(),
      'ToDate': selectedaterange.end.toString(),
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      String _url = mainurl + '/leadresponse/callhistory_app.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          leadresponsehistory.value = List<LeadResponse>.from(
              data['ResultData'].map((x) => LeadResponse.fromJson(x)));
          responsehistoryshow.value = leadresponsehistory;
        } else {
          leadresponsehistory.clear();
          responsehistoryshow.clear();
        }
      }
    } catch (e) {
      debugPrint('getreponsehistry :$e');
    }
    issearching.value = false;
  }

  ditictresponse() {
    distinctresponse.clear();
    Get.find<LogeduserControll>().compResponses.forEach((element) {
      distinctresponse.add(element.response);
    });
  }

  String getresponsecount(String value) {
    int _count = 0;
    for (var element in leadresponsehistory) {
      if (element.response!.toLowerCase() == value.toLowerCase()) {
        _count++;
      }
    }

    return _count.toString();
  }

  getsearchresult(String value, bool excatmatch) {
    if (value.length >= 3) {
      String _value = value.toLowerCase();
      List<LeadResponse> locallist = [];
      for (var element in leadresponsehistory) {
        var data = element.toJson();
        var isfounded = false;
        data.forEach((key, value) {
          if (isfounded) return;
          if (excatmatch) {
            if (value.toString().toLowerCase() == _value) {
              locallist.add(element);
              isfounded = true;
            }
          } else {
            if (value.toString().toLowerCase().contains(_value)) {
              locallist.add(element);
              isfounded = true;
            }
          }
        });
      }
      responsehistoryshow.value = locallist;
    } else {
      responsehistoryshow.value = leadresponsehistory;
    }
  }
}
