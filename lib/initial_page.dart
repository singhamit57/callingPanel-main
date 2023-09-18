import 'package:callingpanel/pages/adduser/adduser_controller.dart';
import 'package:callingpanel/pages/admin/admin_controller.dart';
import 'package:callingpanel/pages/callerworkreport/callerworkreport_controller.dart';
import 'package:callingpanel/pages/callhistory/callhistory_controller.dart';
import 'package:callingpanel/pages/companies/company_controller.dart';
import 'package:callingpanel/pages/configurations/adddepartments/departmentpage_controll.dart';
import 'package:callingpanel/pages/configurations/addresponses/responses_controll.dart';
import 'package:callingpanel/pages/configurations/configuration_controller.dart';
import 'package:callingpanel/pages/leads/leadpage_controll.dart';
import 'package:callingpanel/pages/manager/mager_controller.dart';
import 'package:callingpanel/pages/reports/report_controller.dart';
import 'package:callingpanel/pages/telecaller/telecaller_controller.dart';
import 'package:callingpanel/pages/uploaddata/adddata_controller.dart';
import 'package:callingpanel/various_keys.dart';
import 'package:callingpanel/widgets/appbar/appbar.dart';
import 'package:callingpanel/widgets/drawer/drawer.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'controllers/pageswitch_controller.dart';
import 'controllers/reportupdatecontroller.dart';
import 'widgets/appbar/appbar_controller.dart';
import 'widgets/drawer/drawer_control.dart';
import 'widgets/workarea/workarea_controller.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

WorkPageController? controller;

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    Get.put(Appbarcontroller());
    Get.put(MyDrawerControll());
    Get.put(WorkPageController());
    Get.put(LeadPageCtrl());
    Get.put(MangerListCtrl());
    Get.put(TelecallerListCtrl());
    Get.put(AddEditUserController());
    Get.put(AddDataControll());
    Get.put(DepartmetnPageCtrl());
    Get.put(ResponsePageCtrl());
    Get.put(ReportPageCtrl());
    Get.put(ConfigurationPageCtrl());
    Get.put(CallHistoryWebCtrl());
    Get.put(ReportUpdateCtrl());
    Get.put(CompanyPageCtrl());
    Get.put(AdminPageWebCtrl());
    // Get.put(DashBoardCtrl());
    Get.put(CallerWorkReportWebCtrl());
    controller = Get.find<WorkPageController>();
    controller!.onpageload();
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => Get.find<ReportUpdateCtrl>().startcheckreport());
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('Dispose');
    Get.find<ReportUpdateCtrl>().checkreport = false;
    Get.find<Appbarcontroller>().appbarheading.value = PageSwitch.dashboard;
    Get.find<MyDrawerControll>().selectedpage.value = PageSwitch.dashboard;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller!.context = context;
    return WillPopScope(
      onWillPop: () async {
        controller!.setworkpage('', isback: true);
        return false;
      },
      child: Scaffold(
          key: ImportentKeys.initialpagekey,
          backgroundColor: Get.theme.colorScheme.surface,
          drawer: MyDrawer(),
          appBar: const PreferredSize(
            child: MyAppbar(),
            preferredSize: Size.fromHeight(70),
          ),
          body: LayoutBuilder(builder: (context, constrains) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ResponsiveLayout.isComputer(context)) MyDrawer(),
                Expanded(
                    flex: 2,
                    child: Scaffold(
                      key: ImportentKeys.workpagepagekey,
                      body: Obx(
                        () => controller!.shownewpage(),
                      ),
                      // body: ManagerListPage(),
                    )),
              ],
            );
          })),
    );
  }
}
