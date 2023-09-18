import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/constants/material_color.dart';
import 'package:callingpanel/controllers/badic_req_ctrl.dart';
import 'package:callingpanel/pages/dashboard/dashboardpages/dashboard_controller.dart';
import 'package:callingpanel/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/logedusercontroller.dart';
import 'pages/login/loginpage_controll.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  Vx.setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   systemNavigationBarColor: darkslategray,
  //   statusBarColor: darkslategray,
  //   statusBarBrightness: Brightness.dark,
  // ));

  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(0xffff6920)));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appname,
      initialBinding: ControllerBinding(),
      theme: lightThemeData,
      home: const LoginPage(),
      // home: const PrivacyPolicyPage(),
      // initialRoute: '/',
      unknownRoute: GetPage(
          name: '/',
          page: () {
            return const LoginPage();
          }),
      // getPages: [
      //   GetPage(
      //       name: '/',
      //       page: () {
      //         return const LoginPage();
      //       }),
      // ],
    );
  }
}

class ControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LogeduserControll(), permanent: true);
    Get.put(LoginPageCtrl());
    Get.put(BasicReqCtrl());
    //temp ctrl
    // Get.put(Appbarcontroller());
    Get.put(DashBoardCtrl());
    // Get.put(MyDrawerControll());
    // Get.put(WorkPageController());
    // Get.put(LeadPageCtrl());
    // Get.put(MangerListCtrl());
    // Get.put(TelecallerListCtrl());
    // Get.put(AddEditUserController());
    // // Get.put(AddDataControll());
    // // Get.put(DepartmetnPageCtrl());
    // // Get.put(ResponsePageCtrl());
    // // Get.put(ReportPageCtrl());
    // // Get.put(ConfigurationPageCtrl());
    // Get.put(CallHistoryWebCtrl());
    // Get.put(ReportUpdateCtrl());
    // Get.put(CompanyPageCtrl());
    // Get.put(AdminPageWebCtrl());
  }
}

/*
inport universerl  show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import convert
final List<int> bytes = workbook.saveAsStream();
Simple Code for redirecting to download URL
import 'dart:html' as html;
void downloadFile(String url){
   html.AnchorElement anchorElement =  new html.AnchorElement(href: url);
   anchorElement.download = url;
   anchorElement.click();
}


if(kisweb){
  AnchorElement('data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')..setAttribute('download','output.xlsx')..click();
}
6Places appbar, constants, puspec, index.htlm, androidmainfest, connectionurl
flutter pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main


*/
