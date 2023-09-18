import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/functions/storage/storagefiles/savenewlead.dart';
import 'package:callingpanel/functions/storage/storagekeys.dart';
import 'package:callingpanel/mobileapp/appscreens/callhistory/callhistory_controll.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/outgoingcallview/outgoingcallview_controller.dart';
import 'package:callingpanel/mobileapp/appscreens/newdatapage/newdata_controll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart' as http;

class CallResponseCtrlM extends GetxService {
  @override
  void onReady() {
    getdepartlist(
      havedata: false,
    );
    super.onReady();
  }

  var namectrl = TextEditingController();
  var mobilectrl = TextEditingController();
  var altmobilectrl = TextEditingController();
  var emailctrl = TextEditingController();
  var profilectrl = TextEditingController();
  var countryctrl = TextEditingController();
  var statectrl = TextEditingController();
  var cityctrl = TextEditingController();
  var remarkctrl = TextEditingController();
  var meetingdateshow = 'Select Date'.obs;
  var selecteddepart = 'Select Department'.obs;
  var selectedresponse = 'Select Response'.obs;
  var selecteddate = DateTime.now().obs;
  var selectedpriority = 'Select Priority'.obs;
  var selectedresult = 'Select Result'.obs;
  var departoptions = <String>['Select Department'].obs;
  var responseoptions = <String>['Select Response'].obs;
  var needdate = false.obs;
  var needremark = false.obs;
  var buttonstate = ButtonState.idle.obs;
  var issearching = false.obs;

  getdepartlist({String? departindata, required bool havedata}) {
    needdate.value = false;

    List<String> _localdepart = ['Select Department'];
    Get.find<LogeduserControll>().comDepartmentList.forEach((item) {
      if (item.department != null) {
        if (!_localdepart.contains(item.department!)) {
          _localdepart.add(item.department!);
        }
      }
    });
    if (havedata && departindata != null) {
      if (!_localdepart.contains(departindata) && departindata.length >= 2) {
        _localdepart.add(departindata);
        selecteddepart.value = departindata;
      }
      departoptions.value = _localdepart;
      getresponselist(departindata);
    }
  }

  getresponselist(String depart) {
    if (depart == 'Select Department') return;
    // responseoptions.clear();
    // responseoptions.add('Select Response');
    List<String> _localResp = ['Select Response'];
    selectedresponse.value = "Select Response";
    Get.find<LogeduserControll>().comDepartmentList.forEach((item) {
      if (item.department == depart) {
        for (var element in item.responses!) {
          _localResp.add(element);
        }
      }
    });

    responseoptions.value = _localResp;
  }

  needmeetdate(String response) {
    needdate.value = false;
    if (response == 'Select Response') return;
    Get.find<LogeduserControll>().compResponses.forEach((element) {
      if (element.response == response && element.needIntDate) {
        needdate.value = true;
      }
    });
    needanyremark(response);
  }

  needanyremark(String response) {
    needremark.value = false;
    if (response == 'Select Response') return;
    Get.find<LogeduserControll>().compResponses.forEach((element) {
      if (element.response == response && element.needRemark) {
        needremark.value = true;
      }
    });
  }

  changebtnstate(int index) async {
    if (index <= 3) {
      buttonstate.value = states[index];
      if (index >= 2) {
        await Future.delayed(const Duration(seconds: 3));
        buttonstate.value = states[0];
      }
    }
  }

  savevalidation(
      {required String tableid,
      required String datatype,
      required context,
      required bool havedata}) {
    if (datatype == 'newdata') {
      if (namectrl.text.length < 3) {
        alertsncabar('Please enter full name...');
        return;
      }
      if (mobilectrl.text.length < 3) {
        alertsncabar('Please enter mobile number...');
        return;
      }

      if (profilectrl.text.length < 2) {
        alertsncabar('Please fill profile...');
        return;
      }
      if (countryctrl.text.length < 2) {
        alertsncabar('Please fill country name...');
        return;
      }

      if (statectrl.text.length < 2) {
        alertsncabar('Please fill state name...');
        return;
      }
      if (cityctrl.text.length < 2) {
        alertsncabar('Please fill city name...');
        return;
      }
    }
    if (datatype == 'callhistory' || datatype == 'leaddata') {
      if (selecteddepart.value == 'Select Department') {
        alertsncabar('Please select department...');
        return;
      }

      if (selectedresponse.value == 'Select Response') {
        alertsncabar('Please select response...');
        return;
      }

      // ignore: unrelated_type_equality_checks
      if (needdate.value && meetingdateshow == 'Select Date') {
        alertsncabar('Please select meeting date...');
        return;
      }
      // ignore: unrelated_type_equality_checks
      if (needdate.value && selectedpriority == 'Select Priority') {
        alertsncabar('Please select lead priority...');
        return;
      }
      if (needdate.value && remarkctrl.text.length < 6) {
        alertsncabar('Please write some remark...');
        return;
      }
      if (needremark.value && remarkctrl.text.length < 6) {
        alertsncabar('Please write some remark...');
        return;
      }
      if (selectedresult.value == 'Select Result') {
        alertsncabar('Please select lead result...');
        return;
      }
    }

    savelead(
        havedata: havedata,
        tableid: tableid,
        datatype: datatype,
        context: context);
  }

  savelead(
      {required context,
      required String tableid,
      datatype,
      required bool havedata}) async {
    changebtnstate(1);
    var localdata = await getleadlocally();
    String _url = mainurl + '/leadresponse/leadresponse_app.php';
    var body = {
      'CompId': Get.find<LogeduserControll>().logeduserdetail.value.compId,
      'CompName': Get.find<LogeduserControll>().logeduserdetail.value.compName,
      'UserID': Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      'UserName':
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      'UserDepart': Get.find<LogeduserControll>()
          .logeduserdetail
          .value
          .logeduserDepartment,
      'TableID': tableid,
      'DataType': datatype,
      'HaveData': havedata,
      'FullName': namectrl.text,
      'Mobile': mobilectrl.text,
      'AltMobile': altmobilectrl.text,
      'Email': emailctrl.text,
      'Profile': profilectrl.text,
      'Country': countryctrl.text,
      'State': statectrl.text,
      'City': cityctrl.text,
      'SelectedDepart': selecteddepart.value,
      'SelectedResponse': selectedresponse.value,
      'ShowMeetDate': meetingdateshow.value,
      'MeetingDate': selecteddate.value.toString(),
      'Priority': selectedpriority.value,
      'Remark': remarkctrl.text,
      'FinalResult': selectedresult.value,
      "CallRecordingID": Get.find<OutgoincallviewCtrl>().uniquecallId,
      'callstart': localdata[StorageKeys.callstarttime],
      'callend': localdata[StorageKeys.callendtime],
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          changebtnstate(2);
          if (datatype != "newdata") {
            Get.find<MobileNewDataCtrl>().getfollowlist();
            Get.find<CallHistoryCtrl>().getreponsehistry();
          }

          await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context, true);
        } else {
          showsnackbar(titel: 'Failed !!!', detail: data['Msj']);
          changebtnstate(3);
        }
      } else {
        changebtnstate(3);
      }
    } catch (e) {
      showsnackbar(titel: 'Failed !!!', detail: 'Someting is worng...');
      debugPrint("savelead : $e");
      changebtnstate(3);
    }
  }
}

List<ButtonState> states = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail,
];

alertsncabar(String msj) {
  showsnackbar(titel: 'Alert !!!', detail: msj);
}
