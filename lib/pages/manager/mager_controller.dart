import 'dart:convert';
import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/search_filter.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/manager/addedituser_model.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Appbarcontroller? appbarctrl;

class MangerListCtrl extends GetxController {
  var managerslist = <NewUserModel>[].obs;
  var allmanagerslist = <NewUserModel>[].obs;
  var issearching = false.obs;

  @override
  void onInit() {
    appbarctrl = Get.find<Appbarcontroller>();
    super.onInit();
  }

  getrecords() async {
    issearching.value = true;
    managerslist.clear();
    allmanagerslist.clear();
    String _url = mainurl + '/Users/manager/managerlist.php';
    var body = {
      'CompId': Get.find<LogeduserControll>().logeduserdetail.value.compId,
      'CompName': Get.find<LogeduserControll>().logeduserdetail.value.compName,
      'UserId': Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      'UserName':
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      'Post': 'Manager',
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var alldata = jsonDecode(response.body);

        if (alldata['Status'] == true) {
          allmanagerslist.value =
              newUserlistModelFromJson(jsonEncode(alldata['ResultData']));
          managerslist.value = allmanagerslist;
        } else {
          managerslist.clear();
        }
      }
    } catch (e) {
      managerslist.clear();
      debugPrint('Managergetrecords :$e');
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
        }
      }
    } catch (e) {
      debugPrint('Managerdeleteuserdata :$e');
    }
    issearching.value = false;
  }

  onsearchvalue(String value) {
    if (value.length >= 3) {
      List<int> _indexes = makeserachindata(
        value: value,
        dataList: [...allmanagerslist.map((element) => element.toJson())],
      );
      managerslist.value = _indexes.map((e) => allmanagerslist[e]).toList();
    } else {
      managerslist.value = allmanagerslist;
    }
  }
}
