import 'dart:async';
import 'dart:convert';
import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/functions/dio_request.dart';
import 'package:callingpanel/functions/get_location.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/department_model.dart';
import 'package:callingpanel/models/location_model.dart';
import 'package:callingpanel/models/logeduserdetail_model.dart';
import 'package:callingpanel/models/mobileappmodel/messagetemp_model.dart';
import 'package:callingpanel/models/onlineuserdetailmodel.dart';
import 'package:callingpanel/models/permission_model.dart';
import 'package:callingpanel/models/responserequrement_model.dart';
import 'package:callingpanel/pages/dashboard/dashboardpages/dashboard_controller.dart';
import 'package:callingpanel/pages/login/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LogeduserControll extends GetxService {
  @override
  get onDelete {
    islogedin = false;
    return super.onDelete;
  }

  @override
  void onClose() {
    islogedin = false;
    timer!.cancel();
    super.onClose();
  }

  Timer? timer;
  var islogedin = false;
  var showcompoption = false.obs;
  var logeduserdetail = LogedUserDetails().obs;
  var userpermissions = AllowedPermission().obs;
  var comDepartmentList = <DepartmentsModel>[].obs;
  var compResponses = <ResponseRequrements>[].obs;
  var messagetemplates = <MessageTemplates>[].obs;
  var onlineUsersList = <OnlineUserDetailModel>[].obs;
  var currnetworkname = 'login';

  var currnetworkduration = 0;
  var workigplatform = "";
  var isloopworking = false;
  var isuseroncall = false.obs;
  var locationsendcount = 0;
  var currentlocation = LocationModel();
  var locationpermiisonallowed = false.obs;
  var havelocationdata = false;
  int maxtimeLimit = 20;
  var allowedpost = <String>[
    'Select Post',
    'Super Admin',
    'Admin',
    'Manager',
    'Telecaller'
  ].obs;

  setallowposts(String post) {
    if (post == 'Admin') {
      allowedpost.remove('Super Admin');
      allowedpost.remove('Admin');
    }
    if (post == 'Manager') {
      allowedpost.remove('Super Admin');
      allowedpost.remove('Admin');
      allowedpost.remove('Manager');
    }
  }

  getuserpermission() async {
    setallowposts(logeduserdetail.value.logeduserPost);
    try {
      dynamic data = await makehttppost(
          path: '/login/userpermission.php',
          functionname: "getuserpermission",
          data: jsonEncode({
            "id": logeduserdetail.value.logeduserId,
            ...logedUserdetailMap(),
          }));

      if (data == null) return;
      data = jsonDecode(data);
      userpermissions.value = AllowedPermission.fromJson(data['ResultData']);
      if (logeduserdetail.value.logeduserPost == 'Super Admin') {
        showcompoption.value = true;
      } else {
        showcompoption.value = false;
      }
    } catch (e) {
      debugPrint('getuserpermission :$e');
    }
  }

  getcompdeparts() async {
    var body = {
      "Compid": logeduserdetail.value.compId,
      "LogedUserid": logeduserdetail.value.logeduserId,
      ...logedUserdetailMap(),
    };
    try {
      dynamic data = await makehttppost(
        path: '/login/userdepartments.php',
        functionname: "getcompdeparts",
        data: jsonEncode(body),
      );
      if (data == null) return;
      data = jsonDecode(data);
      comDepartmentList.clear();
      if (data['Status'] == true) {
        List<dynamic> result = data['ResultData'];
        for (var str in result) {
          var one = str.toString().split("@@");
          comDepartmentList.add(
            DepartmentsModel(
                department: one[0].toString(),
                tableid: one[2].toString(),
                compid: one[3].toString(),
                responses: one[1].toString().split('#')),
          );
        }
      }
    } catch (e) {
      debugPrint('getcompdeparts :$e');
    }
  }

  getcompresponse() async {
    var body = {
      "Compid": logeduserdetail.value.compId,
      "LogedUserid": logeduserdetail.value.logeduserId,
      ...logedUserdetailMap(),
    };

    try {
      var httpdata = await makehttppost(
        path: '/login/userresponses.php',
        functionname: "getcompresponse",
        data: jsonEncode(body),
      );

      if (httpdata == null) return;
      var data = jsonDecode(httpdata);

      if (data['Status'] == false) return;
      compResponses.value = List<ResponseRequrements>.from(
          data['ResultData'].map((x) => ResponseRequrements.fromJson(x)));
    } catch (e) {
      debugPrint('getcompresponse :$e');
    }
  }

  getmessagetemplates() async {
    try {
      messagetemplates.clear();
      String _path = '/login/usermessagetemplates.php';
      var _body = {
        "CompId": logeduserdetail.value.compId,
        "UserID": logeduserdetail.value.logeduserId,
        ...logedUserdetailMap(),
      };
      dynamic data = await makehttppost(
        path: _path,
        functionname: "getmessagetemplates",
        data: jsonEncode(_body),
      );

      if (data == null) return;
      data = jsonDecode(data);

      if (data['Status'] == true) {
        messagetemplates.value = List<MessageTemplates>.from(
            data['ResultData'].map((x) => MessageTemplates.fromJson(x)));
      }
    } catch (e) {
      debugPrint('getmessagetemplates :$e');
    }
  }

  getOnlineUsers() async {
    if (logeduserdetail.value.logeduserPost == 'Telecaller') return;
    try {
      messagetemplates.clear();
      String _path = '/reports/onlineusersList.php';
      var _body = {
        ...logedUserdetailMap(),
      };
      dynamic data = await makehttppost(
        path: _path,
        functionname: "getOnlineUsers",
        data: jsonEncode(_body),
      );
      if (data == null) return;
      data = jsonDecode(data);
      if (data['Status'] == true) {
        onlineUsersList.value = List<OnlineUserDetailModel>.from(
            data['ResultData'].map((x) => OnlineUserDetailModel.fromJson(x)));
      }
    } catch (e) {
      debugPrint('getmessagetemplates :$e');
    }
  }

  startTimer() {
    // timer = Timer.periodic(Duration(seconds: maxtimeLimit), (timer) {
    //   islogedin = false;
    //   timer.cancel();
    //   Get.off(const LoginPage());
    // });
  }

  resetTimer() {
    if (timer == null ? false : timer!.isActive) {
      timer!.cancel();
      startTimer();
    }
  }

  var loopduration = 10;
  logeduserworkloop() async {
    isloopworking = true;
    locationsendcount = 0;
    while (islogedin) {
      await updatworkTime();
      await Future.delayed(Duration(seconds: loopduration));
      await getOnlineUsers();
      await Get.find<DashBoardCtrl>().getdashboardData();
      locationsendcount = locationsendcount + 1;
      if (locationsendcount > 5) {
        locationsendcount = 0;
      }
    }
  }

  updatworkTime() async {
    try {
      String _url = mainurl + '/Users/userworkhrs_app.php';
      havelocationdata = false;
      if (locationsendcount == 1) {
        if (locationpermiisonallowed.value) {
          await getcurrentlocation();
        }
      }

      var _body = {
        'CompID': logeduserdetail.value.compId,
        'UserID': logeduserdetail.value.logeduserId,
        'workDate': DateTime.now().toString(),
        'lable': currnetworkname,
        'Workpageduration': currnetworkduration,
        'duration': loopduration,
        'LoginKey': logeduserdetail.value.loginKey,
        'havelocation': (havelocationdata && locationsendcount == 0),
        'RoundCount': locationsendcount,
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'accuracy': currentlocation.accuracy,
        'speed': currentlocation.speed,
        ...logedUserdetailMap(),
      };

      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(_body));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Islogedin'] == false) {
          islogedin = false;
          Get.off(const LoginPage());
          showsnackbar(
              titel: 'Alert !!!',
              detail: 'You are login from another place...');
        }
      }
    } catch (e) {
      debugPrint('updatworkTime :$e');
    }
  }

  Map logedUserdetailMap() {
    return {
      "LogedUserCompId": logeduserdetail.value.compId,
      "LogedUserCompName": logeduserdetail.value.compName,
      "LogedUserCompStatus": logeduserdetail.value.compStatus,
      "LogedUsersId": logeduserdetail.value.logeduserId,
      "LogedUsersName": logeduserdetail.value.logeduserName,
      "LogedUsersDataCode": logeduserdetail.value.logeduserDatacode,
      "LogedUserLoginKey": logeduserdetail.value.loginKey,
      "LogedUsersPost": logeduserdetail.value.logeduserPost,
      "LogedUsers": logeduserdetail.value.logeduserDepartment![0],
      "LogedAddDeparts": userpermissions.value.addEditDepartmetn,
      "LogedAddResponse": userpermissions.value.addEditResponse,
      "LogedAddUser": userpermissions.value.addEditUser,
      "LogedAddLead": userpermissions.value.addEditLead,
      'LogedViewReport': userpermissions.value.viewReports,
      'LogedUpdateReport': userpermissions.value.updateReport,
      'LogedMakeCall': userpermissions.value.makeCall,
      'LogedSendSms': userpermissions.value.sendSms,
      'LogedSendMail': userpermissions.value.sendMail,
      'AppVersion': Constants.appversion,
      "WorkingPlatform": workigplatform,
    };
  }
}

List<String> allposts = [
  'Select Post',
  'Super Admin',
  'Admin',
  'Manager',
  'Telecaller'
];
