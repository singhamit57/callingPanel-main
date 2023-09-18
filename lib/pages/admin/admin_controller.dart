import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/search_filter.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/manager/addedituser_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class AdminPageWebCtrl extends GetxService {
  var adminsList = <NewUserModel>[].obs;
  var alladminsList = <NewUserModel>[];
  var issearching = false.obs;
  getrecords() async {
    issearching.value = true;

    String _url = mainurl + '/Users/manager/managerlist.php';
    var body = {
      'CompId': Get.find<LogeduserControll>().logeduserdetail.value.compId,
      'CompName': Get.find<LogeduserControll>().logeduserdetail.value.compName,
      'UserId': Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      'UserName':
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      'Post': 'Admin',
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var alldata = jsonDecode(response.body);
        if (alldata['Status'] == true) {
          alladminsList = List<NewUserModel>.from(
              alldata['ResultData'].map((x) => NewUserModel.fromJson(x)));
          adminsList.value = alladminsList;
        } else {
          adminsList.clear();
          alladminsList.clear();
        }
      }
    } catch (e) {
      adminsList.clear();
      alladminsList.clear();
      debugPrint('admingetrecords :$e');
    }
    issearching.value = false;
  }

  deleteuserdata({
    required String tableid,
    required String deleteuserid,
  }) async {
    issearching.value = true;
    String _url = mainurl + '/Users/deleteoneuser.php';
    var body = {
      'CompId': Get.find<LogeduserControll>().logeduserdetail.value.compId,
      'CompName': Get.find<LogeduserControll>().logeduserdetail.value.compName,
      'LogedUserId':
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      'LogedUserName':
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      'DeleteUserId': deleteuserid,
      'Tableid': tableid,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var alldata = jsonDecode(response.body);
        if (alldata['Status'] == true) {
          await getrecords();
          showsnackbar(titel: 'Success !!!', detail: alldata['Msj']);
        } else {
          showsnackbar(titel: 'Failed !!!', detail: alldata['Msj']);
          adminsList.clear();
        }
      }
    } catch (e) {
      debugPrint('admindeleteuserdata :$e');
    }
    issearching.value = false;
  }

  onsearchvalue(
    String value,
  ) {
    if (value.length >= 3) {
      List<int> _indexes = makeserachindata(
        value: value,
        dataList: [
          ...alladminsList.map((e) => e.toJson()),
        ],
      );
      adminsList.value = _indexes.map((i) => alladminsList[i]).toList();
    } else {
      adminsList.value = alladminsList;
    }
  }
}
