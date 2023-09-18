import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/search_filter.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/manager/addedituser_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class TelecallerListCtrl extends GetxController {
  var telecallerList = <NewUserModel>[].obs;
  var alltelecallerList = <NewUserModel>[];
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
      'Post': 'Telecaller',
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var alldata = jsonDecode(response.body);

        if (alldata['Status'] == true) {
          alltelecallerList = List<NewUserModel>.from(
              alldata['ResultData'].map((x) => NewUserModel.fromJson(x)));
          telecallerList.value = alltelecallerList;
        } else {
          telecallerList.clear();
          alltelecallerList.clear();
        }
      }
    } catch (e) {
      telecallerList.clear();
      alltelecallerList.clear();
      debugPrint('Telegetrecords :$e');
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
          telecallerList.clear();
        }
      }
    } catch (e) {
      debugPrint('Teledeleteuserdata :$e');
    }
    issearching.value = false;
  }

//telecallerList.value = alltelecallerList;
  onsearchvalue(String value) {
    if (value.length >= 2) {
      List<int> _indexes = makeserachindata(
        value: value,
        dataList: [...alltelecallerList.map((element) => element.toJson())],
      );
      telecallerList.value = _indexes.map((e) => alltelecallerList[e]).toList();
    } else {
      telecallerList.value = alltelecallerList;
    }
  }
}
