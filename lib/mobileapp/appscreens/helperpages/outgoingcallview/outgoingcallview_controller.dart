import 'dart:async';

import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/make_call.dart';
import 'package:get/get.dart';

class OutgoincallviewCtrl extends GetxService {
  LogeduserControll? logeduserControll;
  int totalcallduration = 0;
  String frompageName = "";
  String leadId = "";
  List<dynamic> addinalinfo = [];
  String uniquecallId = "";
  Timer? timer;
  var minutes = 0.obs;
  var secounds = 0.obs;
  int durationinsec = 0;
  var isendedcall = false.obs;
  var isrecording = false.obs;

  oncallstart({
    String? frompagename,
    String? leadId,
  }) {
    logeduserControll = Get.find<LogeduserControll>();
    frompageName = frompagename ?? "";
    leadId = leadId;
    uniquecallId = "";
    generatecallID(logeduserControll!.logeduserdetail.value.logeduserId);
    timer?.cancel();
    durationinsec = 0;
    isendedcall.value = false;
    // startCallRecord();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationinsec++;
      minutes.value = (durationinsec ~/ 60);
      secounds.value = (durationinsec % 60);
      logeduserControll!.currnetworkduration = durationinsec;
    });
  }

  // startCallRecord() async {
  //   isrecording.value = await startAudiRecord(
  //       userid:
  //           Get.find<LogeduserControll>().logeduserdetail.value.logeduserId!);
  // }

  generatecallID(String userid) {
    uniquecallId = userid + DateTime.now().toString() + "recording";
    uniquecallId = uniquecallId
        .replaceAll("-", "")
        .replaceAll(" ", "")
        .replaceAll(":", "")
        .replaceAll(".", "");
  }

  oncallEnd() {
    // if (frompageName == "NewDataPage") {
    //   Get.off(() => const MobileNewDataPage(
    //         frompage: "OutgoinCallViewPage",
    //       ));
    // }
    // if (frompageName == "MobileAppCallHistory") {
    //   Get.off(() => const MobileAppCallHistory());
    // }
    // if (frompageName == "MobileFullCallHistory") {
    //   Get.off(() => MobileFullCallHistory(
    //         frompage: addinalinfo[0],
    //         mobile: addinalinfo[1],
    //         tableid: addinalinfo[2],
    //         leadid: addinalinfo[3],
    //         name: addinalinfo[4],
    //       ));
    // }
    // if (frompageName == "MobileCallResponsePage") {
    //   Get.off(() => const MobileCallResponsePage());
    // }
    Get.back();
    updatecallstamp(
      operation: "End",
      leadid: leadId,
    );
  }
}
