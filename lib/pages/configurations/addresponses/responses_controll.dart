import 'dart:convert';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/dio_request.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/responserequrement_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

class ResponsePageCtrl extends GetxController {
  var responseTitel = 'Create Response'.obs;
  var compIdCtrl = TextEditingController().obs;
  var compNameCtrl = TextEditingController().obs;
  var responseCtrl = TextEditingController().obs;
  var editresponse = ResponseRequrements();
  var needintdate = false.obs;
  var needremark = false.obs;
  var needsendsms = false.obs;
  var needsendmail = false.obs;
  var buttonstate = ButtonState.idle.obs;
  var issearching = false.obs;
  updatebuttonstatus(int index) async {
    if (index <= 3) {
      buttonstate.value = buttonstateList[index];
    }
    if (index >= 2) {
      await Future.delayed(const Duration(seconds: 3));
      buttonstate.value = buttonstateList[0];
    }
  }

  onloadpage({ResponseRequrements? editdata}) {
    if (editdata == null) {
      editresponse = ResponseRequrements();
      responseTitel.value = 'Create Responses';
      compIdCtrl.value.text = '';
      compNameCtrl.value.text = '';
      responseCtrl.value.text = '';
      needintdate.value = false;
      needremark.value = false;
      needsendsms.value = false;
      needsendmail.value = false;
    } else {
      responseTitel.value = 'Edit Responses';
      editresponse = editdata;
      compIdCtrl.value.text = '';
      compNameCtrl.value.text = '';
      responseCtrl.value.text = editdata.response;
      needintdate.value = editdata.needIntDate;
      needremark.value = editdata.needRemark;
      needsendsms.value = editdata.sendSms;
      needsendmail.value = editdata.sendMail;
    }
  }

  saveresponse() async {
    if (Get.find<LogeduserControll>().showcompoption.value) {
      if (compIdCtrl.value.text.length < 3) {
        showsnackbar(titel: 'Alert !!!', detail: 'Please enter company id...');
        return false;
      }
      if (compNameCtrl.value.text.length < 3) {
        showsnackbar(
            titel: 'Alert !!!', detail: 'Please enter valid company id...');
        return false;
      }
    }

    if (responseCtrl.value.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter response name...');
      return false;
    }

    updatebuttonstatus(1);
    var body = {
      "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "CompName": Get.find<LogeduserControll>().logeduserdetail.value.compName,
      "Response": responseCtrl.value.text,
      "NeedIntDate": needintdate.value ? '1' : '0',
      "NeedRemark": needremark.value ? '1' : '0',
      "SendSms": needsendsms.value ? '1' : '0',
      "SendMail": needsendmail.value ? '1' : '0',
      "LogedID":
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      "TableId": editresponse.tableid,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      dynamic data = await makehttppost(
        path: '/configuration/addeditresponses.php',
        functionname: "saveresponse",
        data: jsonEncode(body),
      );
      if (data == null) return;
      data = jsonDecode(data);
      if (data['Status'] == true) {
        await Get.find<LogeduserControll>().getcompresponse();
        showsnackbar(titel: 'Success !!!', detail: data['Msj'].toString());
        updatebuttonstatus(2);
        onloadpage();
      } else {
        showsnackbar(titel: 'Failed !!!', detail: data['Msj'].toString());
        updatebuttonstatus(3);
      }
    } catch (e) {
      showsnackbar(titel: 'Failed !!!', detail: 'Something is wrong...');
      updatebuttonstatus(3);
    }
  }
}

var buttonstateList = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail
];
