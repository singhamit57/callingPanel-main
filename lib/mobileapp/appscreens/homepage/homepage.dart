import 'dart:async';

import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/mobileapp/appscreens/callerdetails/callerdetails_page.dart';
import 'package:callingpanel/mobileapp/appscreens/callhistory/callhistory_controll.dart';
import 'package:callingpanel/mobileapp/appscreens/callhistory/callhistory_page.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/outgoingcallview/outgoingcallview_controller.dart';
import 'package:callingpanel/mobileapp/appscreens/newdatapage/newdata_controll.dart';
import 'package:callingpanel/mobileapp/appscreens/newdatapage/newdata_page.dart';
import 'package:callingpanel/mobileapp/appscreens/setting/mobileappsetting_page.dart';
import 'package:callingpanel/mobileapp/mobilewidgets/bottum_navigation/buttomnavigation_controll.dart';
import 'package:callingpanel/mobileapp/mobilewidgets/callresponsepage.dart/callresponse_controller.dart';
import 'package:callingpanel/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

ButtomNavigationCtrl? buttomnavigationctrl;
MobileNewDataCtrl? mobileNewDataCtrl;
LogeduserControll? logeduserctrl;

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({Key? key}) : super(key: key);

  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with WidgetsBindingObserver {
  int inactiveduration = 0;
  Timer? timer;

  @override
  void initState() {
    buttomnavigationctrl = Get.put(ButtomNavigationCtrl());
    Get.put(CallResponseCtrlM());
    Get.put(MobileNewDataCtrl());
    Get.put(CallHistoryCtrl());
    Get.put(OutgoincallviewCtrl());
    logeduserctrl = Get.find<LogeduserControll>();
    logeduserctrl!.getmessagetemplates();
    mobileNewDataCtrl = Get.find<MobileNewDataCtrl>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CallHistoryCtrl>().getreponsehistry();
      mobileNewDataCtrl!.getnewdata();
      mobileNewDataCtrl!.getfollowlist();
    });
    WidgetsBinding.instance.addObserver(this);
    timer?.cancel();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      logeduserctrl!.islogedin = false;
    }
    if (state == AppLifecycleState.inactive) {
      inactiveduration = 0;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        inactiveduration++;
        if (inactiveduration >= 3600) {
          logeduserctrl!.islogedin = false;
          Get.off(() => const LoginPage());
        }
      });
    }
    if (state == AppLifecycleState.resumed) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Scaffold(
                  // bottomNavigationBar: ConstrainedBox(
                  //     constraints: const BoxConstraints(maxWidth: 700),
                  //     child: buttomnavigation(controll: buttomnavigationctrl!)),
                  bottomNavigationBar: Obx(() => BottomNavigationBar(
                        currentIndex: buttomnavigationctrl!.selectedtab.value,
                        elevation: 8,
                        backgroundColor: Get.theme.colorScheme.background,
                        selectedItemColor: Get.theme.colorScheme.onSecondary,
                        unselectedItemColor: Get.theme.colorScheme.primary,
                        type: BottomNavigationBarType.fixed,
                        showUnselectedLabels: true,
                        onTap: (index) {
                          buttomnavigationctrl!.selectedtab.value = index;
                        },
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.add_ic_call),
                            label: 'call',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.compare_arrows),
                            label: 'History',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person),
                            label: 'Profile',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.settings),
                            label: 'Settings',
                          ),
                        ],
                      )),
                  body: Obx(() =>
                      appscreens[buttomnavigationctrl!.selectedtab.value]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// List<int> allowedappbar = [0, 2];

List<Widget> appscreens = [
  const MobileNewDataPage(),
  const MobileAppCallHistory(),
  const MobileCallerDetailPage(),
  const MobileSettingsPage(),
];
