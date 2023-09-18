import 'package:callingpanel/constants/const_enums.dart';
import 'package:callingpanel/models/find_ctrl.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:phone_plus/phone_plus.dart';

class BasicReqCtrl extends GetxService {
  bool iscallbyapp = false;
  String lastcallednumber = "";
  late PhonePlus phonePlus;
  var phonestatus = PhonePlusState.none.obs;

  _oncallend() {
    if (iscallbyapp) {
      iscallbyapp = false;
    }
  }

  @override
  void onReady() {
    initPhonestate();
    super.onReady();
  }

  initPhonestate() async {
    phonePlus = PhonePlus();

    phonePlus.setIncomingCallReceivedHandler((date, number) {
      debugPrint("$date => $number");
      phonestatus.value = PhonePlusState.incomingReceived;
    });

    phonePlus.setIncomingCallAnsweredHandler((date, number) {
      debugPrint("$date => $number");
      phonestatus.value = PhonePlusState.incomingAnswered;
    });

    phonePlus.setIncomingCallEndedHandler((date, number) {
      debugPrint("$date => $number");
      FindCtrl.outgoingview.oncallEnd();

      phonestatus.value = PhonePlusState.incomingEnded;
    });

    phonePlus.setOutgoingCallStartedHandler((date, number) {
      debugPrint("$date => $number");
      phonestatus.value = PhonePlusState.outgoingStarted;
    });

    phonePlus.setOutgoingCallEndedHandler((date, number) {
      debugPrint("$date => $number");
      FindCtrl.outgoingview.oncallEnd();
      phonestatus.value = PhonePlusState.outgoingEnded;
      _oncallend();
    });

    phonePlus.setMissedCallHandler((date, number) {
      debugPrint("$date => $number");
      phonestatus.value = PhonePlusState.missedCall;
    });

    phonePlus.setErrorHandler((msg) {});
  }
}
