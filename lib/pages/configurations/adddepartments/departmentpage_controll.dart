import 'dart:convert';

import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/dio_request.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

class DepartmetnPageCtrl extends GetxController {
  var departmentTitel = 'Create Department'.obs;
  var selectedresponse = <String>[].obs;
  var issearching = false.obs;
  var dataforedit = DepartmentsModel();
  var savebtnstatus = ButtonState.idle.obs;
  var departmentTEC = TextEditingController().obs;
  var compidTEC = TextEditingController();
  var compnameTEC = TextEditingController();

  onloadpage({
    DepartmentsModel? editdata,
  }) {
    if (editdata == null) {
      selectedresponse.clear();
      departmentTitel.value = 'Create Department';
      updatebuttonstatus(0);
      departmentTEC.value.text = '';
      compidTEC.text = '';
      compnameTEC.text = '';
      dataforedit = DepartmentsModel();
    } else {
      departmentTitel.value = 'Edit Department';
      dataforedit = editdata;
      compidTEC.text = editdata.compid ?? '';
      compnameTEC.text = '';
      departmentTEC.value.text = editdata.department ?? '';
      selectedresponse.value = editdata.responses!;
    }
  }

  updatebuttonstatus(int index) async {
    if (index <= 3) {
      savebtnstatus.value = btnstatelist[index];
    }
    if (index >= 2) {
      await Future.delayed(const Duration(seconds: 3));
      savebtnstatus.value = btnstatelist[0];
    }
  }

  saveDepartment() async {
    if (Get.find<LogeduserControll>().showcompoption.value) {
      if (compidTEC.text.length < 3) {
        showsnackbar(titel: 'Alert !!!', detail: 'Please enter company id...');
        return false;
      }
      if (compnameTEC.text.length < 3) {
        showsnackbar(
            titel: 'Alert !!!', detail: 'Please enter valid company id...');
        return false;
      }
    }

    if (departmentTEC.value.text.length < 4) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please fill department...');
      return;
    }
    if (selectedresponse.isEmpty) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please select responses...');
      return;
    }

    updatebuttonstatus(1);
    var body1 = {
      "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "CompName": Get.find<LogeduserControll>().logeduserdetail.value.compName,
      "LogedID":
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      "Department": departmentTEC.value.text,
      "Responses": selectedresponse,
      "Tableid": dataforedit.tableid,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      dynamic data = await makehttppost(
        path: '/configuration/addeditdepartment.php',
        functionname: "saveDepartment",
        data: jsonEncode(body1),
      );

      if (data == null) return;
      data = jsonDecode(data);
      if (data['Status'] == true) {
        showsnackbar(titel: 'Success !!!', detail: data['Msj'].toString());
        Get.find<LogeduserControll>().getcompdeparts();
        updatebuttonstatus(2);
        dataforedit = DepartmentsModel();
        onloadpage();
      } else {
        showsnackbar(titel: 'Failed !!!', detail: data['Msj'].toString());
        updatebuttonstatus(3);
      }
    } catch (e) {
      debugPrint('updatebuttonstatus :$e');
      showsnackbar(titel: 'Failed !!!', detail: 'Something is wrong...');
      updatebuttonstatus(3);
    }
  }
}

class DepartResponse {
  String response;
  bool isneedl;
  DepartResponse({required this.response, required this.isneedl});
}

var btnstatelist = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail
];
