import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart' as http;

class ChangePasswordCtrlM extends GetxController {
  var currentpwctrl = TextEditingController();
  var newpwctrl = TextEditingController();
  var confirmpwctrl = TextEditingController();
  var buttonstate = ButtonState.idle.obs;

  changebtnstate(int index) async {
    if (index <= 3) {
      buttonstate.value = states[index];
      if (index == 3) {
        await Future.delayed(const Duration(seconds: 3));
        buttonstate.value = states[0];
      }
    }
  }

  Future<bool> changepassword() async {
    changebtnstate(1);

    var userdetails = Get.find<LogeduserControll>().logeduserdetail.value;

    try {
      String url = mainurl + '/Users/changepass_app.php';
      var body = {
        "CompId": userdetails.compId,
        "UserID": userdetails.logeduserId,
        "Newpw": newpwctrl.text,
        "Oldpw": currentpwctrl.text,
        ...Get.find<LogeduserControll>().logedUserdetailMap(),
      };
      http.Response response =
          await http.post(Uri.parse(url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          changebtnstate(2);
          return true;
        } else {
          showsnackbar(
              titel: 'Failed !!!', detail: 'Please enter valid details...');
          changebtnstate(3);
          return false;
        }
      }
    } catch (e) {
      changebtnstate(3);
      showsnackbar(titel: 'Failed !!!', detail: 'Something is wrong...');
      return false;
    }
    changebtnstate(3);
    return false;
  }
}

List<ButtonState> states = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail,
];
