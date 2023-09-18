import 'dart:convert';
import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/functions/storage/storagekeys.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/outgoingcallview/outgoingcallview_controller.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/outgoingcallview/outgoingcallview_page.dart';
import 'package:callingpanel/models/find_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart' as launch;
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

bool iscalledanyone = false;
OutgoincallviewCtrl? outgoincallviewCtrl;

makemycall({
  required context,
  required String mobile,
  required String leadid,
  required String frompagename,
  String? lable,
  String? altmobile,
  String? altlable,
  String? imagepath,
}) async {
  outgoincallviewCtrl = Get.find<OutgoincallviewCtrl>();

  if (altmobile != null && altmobile.length >= 4) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Get.theme.primaryColorDark,
            title: 'Select Number'
                .text
                .size(24)
                .bold
                .color(kdskyblue)
                .makeCentered(),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  final _resp = await makeDirectCall(mobile);
                  if (!_resp) return;
                  // await launch.launch('tel:$mobile');
                  updatecallstamp(
                    operation: 'Start',
                    leadid: leadid,
                  );
                  savelastmakecall(leadid: leadid);

                  iscalledanyone = true;
                  outgoincallviewCtrl!.oncallstart(
                    frompagename: frompagename,
                    leadId: leadid,
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OutgoinCallViewPage(
                                mobile: mobile,
                                fullname: lable,
                                frompagename: frompagename,
                                leadId: leadid,
                                imagepath: imagepath,
                              )));
                },
                child: (lable ?? mobile).text.white.heightLoose.make(),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  final _resp = await makeDirectCall(altmobile);
                  if (!_resp) return;

                  // await launch.launch('tel:$altmobile');
                  updatecallstamp(
                    operation: 'Start',
                    leadid: leadid,
                  );
                  savelastmakecall(leadid: leadid);
                  iscalledanyone = true;
                  outgoincallviewCtrl!.oncallstart(
                    frompagename: frompagename,
                    leadId: leadid,
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OutgoinCallViewPage(
                                mobile: altmobile,
                                fullname: lable ?? "",
                                frompagename: frompagename,
                                leadId: leadid,
                                imagepath: imagepath,
                              )));
                },
                child: (altlable ?? altmobile).text.white.heightLoose.make(),
              ),
            ],
          );
        });
  } else {
    if (mobile.length >= 4) {
      final _resp = await makeDirectCall(mobile);
      if (!_resp) return;
      // await launch.launch('tel:$mobile');
      iscalledanyone = true;
      updatecallstamp(
        operation: 'Start',
        leadid: leadid,
      );
      savelastmakecall(leadid: leadid);
      outgoincallviewCtrl!.oncallstart(
        frompagename: frompagename,
        leadId: leadid,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OutgoinCallViewPage(
                    mobile: mobile,
                    fullname: lable,
                    frompagename: frompagename,
                    leadId: leadid,
                    imagepath: imagepath,
                  )));
    } else {
      showsnackbar(
          titel: 'Alert !!!', detail: 'No valid mobile number', duration: 2);
    }
  }
}

updatecallstamp({
  required String leadid,
  required String operation,
}) async {
  String _url = mainurl + '/leaddatabase/callStartEnd.php';
  var body = {
    "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
    "UserId": Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
    "LeadId": leadid,
    "LocalTimeStamp": DateTime.now().toString(),
    "Operation": operation,
    ...Get.find<LogeduserControll>().logedUserdetailMap(),
  };

  await http.post(Uri.parse(_url), body: jsonEncode(body));
}

savelastmakecall({
  required String leadid,
}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await endlastcall();
  pref.setString(StorageKeys.lastcallleadid, leadid);
  pref.setBool(StorageKeys.wascalled, true);
}

endlastcall() async {
  if (iscalledanyone) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool precall = pref.getBool(StorageKeys.wascalled) ?? false;
    if (precall) {
      String _preleadid = pref.getString(StorageKeys.lastcallleadid) ?? '0';
      await updatecallstamp(
        operation: 'End',
        leadid: _preleadid,
      );
      await pref.setBool(StorageKeys.wascalled, false);
      iscalledanyone = false;
    }
  }
}

bool _havepermissions = false;

Future<bool> makeDirectCall(
  String mobile,
) async {
  if (!_havepermissions) {
    await _checkpermissions();
  }

  if (_havepermissions) {
    bool res = await FlutterPhoneDirectCaller.callNumber(mobile) ?? false;
    final _ct = FindCtrl.basicreq;
    if (res) {
      _ct.iscallbyapp = true;
      _ct.lastcallednumber = mobile;
    }

    return res;
  }
  return false;
}

_checkpermissions() async {
  bool _phone = await Permission.phone.isGranted;
  if (!_phone) {
    _phone = (await Permission.phone.request()).isGranted;
  }

  _havepermissions = _phone;
}
