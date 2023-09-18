import 'dart:convert';
import 'dart:io' as io;

import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/dio_request.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/functions/storage/storagefiles/useridpw_store.dart';
import 'package:callingpanel/initial_page.dart';
import 'package:callingpanel/mobileapp/appscreens/homepage/homepage.dart';
import 'package:callingpanel/models/logeduserdetail_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:url_launcher/url_launcher.dart' as launch;

LogeduserControll? logeduserctrl;

class LoginPageCtrl extends GetxController {
  var showpassword = false.obs;
  var remberpassword = false.obs;
  var useridctrl = TextEditingController();
  var passwordctrl = TextEditingController();
  var buttonstate = ButtonState.idle.obs;

  initialsetup() {
    useridctrl.text = '';
    passwordctrl.text = '';
    logeduserctrl = Get.find<LogeduserControll>();
    logeduserctrl!.isloopworking = false;
    logeduserctrl!.islogedin = false;
  }

  updatebuttonstatus(int index) async {
    if (index <= 3) {
      buttonstate.value = buttonstateList[index];
    }
    await Future.delayed(const Duration(seconds: 3));
    if (index >= 2) {
      buttonstate.value = buttonstateList[0];
    }
  }

  validate() async {
    if (useridctrl.text.length < 6) {
      showsnackbar(titel: 'Warning !', detail: 'Please Enter Your User ID...');
      return;
    }
    if (passwordctrl.text.length < 4) {
      showsnackbar(titel: 'Warning !', detail: 'Please Enter Your Password...');
      return;
    }
    // locationpermissions();
    // if (logeduserctrl!.locationpermiisonallowed.value == false) {
    //   showsnackbar(titel: 'Alert !', detail: 'Please allow location...');
    //   locationpermissions();
    //   await getcurrentlocation();
    //   return;
    // }

    makelogin(
      id: useridctrl.text,
      pw: passwordctrl.text,
    );
  }

  makelogin({
    required String id,
    required String pw,
  }) async {
    updatebuttonstatus(1);

    if (kIsWeb) {
      logeduserctrl!.workigplatform = "Web";
    } else {
      if (io.Platform.isAndroid) {
        logeduserctrl!.workigplatform = "Android";
      }
      if (io.Platform.isWindows) {
        logeduserctrl!.workigplatform = "Windows";
      }
    }

    try {
      dynamic data = await makehttppost(
        path: '/login/login.php',
        functionname: "makelogin",
        data: jsonEncode({
          "id": id,
          "password": pw,
          "AppVersion": Constants.appversion,
          "ScreenSize": Get.width,
          "WorkingPlatform": logeduserctrl!.workigplatform,
        }),
      );

      if (data == null) return;
      data = jsonDecode(data);
      if ((data['Status'] ?? false) == true) {
        if (data['ResultData']['needtoupdate'] == true) {
          showsnackbar(
              titel: 'Alert !!!', detail: 'Please update your application...');
          String updateurl = data['ResultData']['newversionurl'];
          if (updateurl.contains("http")) {
            launch.launchUrl(Uri.parse(updateurl));
          }
          updatebuttonstatus(3);
          return;
        }
        logeduserctrl!.logeduserdetail.value =
            LogedUserDetails.fromJson(data['ResultData']);
        await logeduserctrl!.getuserpermission();
        await logeduserctrl!.getcompdeparts();
        await logeduserctrl!.getcompresponse();
        await logeduserctrl!.getOnlineUsers();

        if (remberpassword.value) {
          savepassword(id: useridctrl.text, pw: passwordctrl.text);
        } else {
          clearidpw();
        }

        logeduserctrl!.islogedin = true;
        logeduserctrl!.logeduserworkloop();
        logeduserctrl!.startTimer();
        updatebuttonstatus(2);
        await Future.delayed(const Duration(milliseconds: 800));

        if (Get.width < 752) {
          if (logeduserctrl!.logeduserdetail.value.logeduserPost ==
                  'Telecaller' ||
              logeduserctrl!.logeduserdetail.value.logeduserPost == 'Manager') {
            Get.off(() => const AppHomeScreen(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 800));
          } else {
            showsnackbar(
                titel: 'Alert !!!',
                detail: 'Please loged in computer device ...');
          }
        } else {
          if (logeduserctrl!.logeduserdetail.value.logeduserPost !=
              'Telecaller') {
            Get.off(() => const InitialPage(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 800));
          } else {
            showsnackbar(
                titel: 'Alert !!!', detail: 'Please loged in mobile device...');
          }
        }
      } else {
        updatebuttonstatus(3);
        showsnackbar(titel: 'Failed !!!', detail: data['Msj'].toString());
      }
    } catch (e) {
      debugPrint('makelogin :$e');
      showsnackbar(titel: 'Failed !!!', detail: 'Somthing is wrong...');
      updatebuttonstatus(3);
    }
  }

  downloadapp(String operation) async {
    showsnackbar(titel: "Please wait !!!", detail: "Processing request...");
    try {
      dynamic data = await makehttppost(
        path: '/login/downloadapps.php',
        functionname: "downloadapp",
        data: jsonEncode({"operation": operation}),
      );

      if (data == null) return;
      data = jsonDecode(data);

      if (data['Status'] == true) {
        if (data['ResultData']['gotapplink'] == true) {
          String appurl = data['ResultData']['applink'] ?? "";
          if (appurl.contains("http")) {
            launch.launchUrl(Uri.parse(appurl));
          } else {
            showsnackbar(
                titel: "Failed !!!", detail: "Please try again later...");
          }
        }
      } else {
        showsnackbar(
            titel: 'Alert !!!', detail: 'Failed to get app package...');
      }
    } catch (e) {
      debugPrint("downloadapp : $e");
      showsnackbar(titel: 'Alert !!!', detail: 'Failed to get app package...');
    }
  }
}

var buttonstateList = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail
];


/*


 drop table ActivityDetails;
 drop table CompaniesDetails;
 drop table CountryCodes;
 drop table DepartmentsDetails;
 drop table DesignationDetails;
 drop table FollowUpHistory;
 drop table LeadResponse;
 drop table LeadsDataBase;
 drop table LoginDetails;
 drop table MailDetails;
 drop table MessageTemplate;
 drop table PermissionDetails;
 drop table ResponsesDetails;
 drop table SmsDetails;
 drop table UpdateHistory;
 drop table UploadedFiles;
 drop table UserDetails;
 drop table UserLocation;
 drop table UserWorkhrs;
 */