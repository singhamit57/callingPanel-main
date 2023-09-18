import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/pages/adduser/addremove_user.dart';
import 'package:callingpanel/pages/admin/admin_page.dart';
import 'package:callingpanel/pages/callerworkreport/callerworkreport_controller.dart';
import 'package:callingpanel/pages/callerworkreport/callerworkreport_web.dart';
import 'package:callingpanel/pages/callhistory/call_history.dart';
import 'package:callingpanel/pages/callhistory/fullhistoryweb_page.dart';
import 'package:callingpanel/pages/companies/copaniesdetails_page.dart';
import 'package:callingpanel/pages/companies/newcompany_page.dart';
import 'package:callingpanel/pages/configurations/adddepartments/addeditdepartmetn.dart';
import 'package:callingpanel/pages/configurations/addresponses/addresponses_page.dart';
import 'package:callingpanel/pages/configurations/configuration_page.dart';
import 'package:callingpanel/pages/dashboard/dashboardpages/dashboard_page1.dart';
import 'package:callingpanel/pages/leads/leads_page.dart';
import 'package:callingpanel/pages/login/login_page.dart';
import 'package:callingpanel/pages/manager/manager_page.dart';
import 'package:callingpanel/pages/notfound/notfound_page.dart';
import 'package:callingpanel/pages/reports/report_page.dart';
import 'package:callingpanel/pages/telecaller/telecaller_page.dart';
import 'package:callingpanel/pages/uploaddata/addeditdata.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/drawer/drawer_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkPageController extends GetxService {
  var workwidgetname = 'Dashboard'.obs;
  List<String> pagehistory = [];
  // ignore: prefer_typing_uninitialized_variables
  var context;
  // var selectedindex = 0.obs;
  // List<String> pagenames = [
  //   'Dashboard',
  //   'Manager',
  //   'Caller',
  //   'Leads',
  //   'Reports',
  //   'Configuration',
  //   'LogOut',
  //   'AddEditUser',
  //   'NewLead',
  //   'AddeditDepart',
  //   'AddeditResponse'
  // ];

  Widget shownewpage() {
    switch (workwidgetname.value) {
      case PageSwitch.dashboard:
        return const DashBoardCharts();
      case PageSwitch.manager:
        return const ManagerListPage();
      case PageSwitch.caller:
        return const TelecallerPage();
      case PageSwitch.leads:
        return const LeadsPage();
      case PageSwitch.reports:
        return const ReportPage();
      case PageSwitch.configuration:
        return const ConfigutaionPage();
      case PageSwitch.logout:
        return const LoginPage();
      case PageSwitch.addedituser:
        return const AddRemoveUsersPage();
      case PageSwitch.newlead:
        return const AddEditDataPage();
      case PageSwitch.addeditdepart:
        return const AddEditDepartment();
      case PageSwitch.addeditresponse:
        return const AddEditResponses();
      case PageSwitch.callhistory:
        return const CallHistoryPage();
      case PageSwitch.fullcallhistory:
        return const FullCallHistoryWeb();
      case PageSwitch.admins:
        return const AdminWebPage();
      case PageSwitch.companies:
        return const AllCompniesDetailPage();
      case PageSwitch.callerfulldetails:
        return const CallerWorkReportWeb();

      case PageSwitch.addeditcompanies:
        return const AddEditCompanyPage();
      default:
        return const NoPageFound();
    }
  }

  List<String> drawertbs = [
    PageSwitch.dashboard,
    PageSwitch.companies,
    PageSwitch.admins,
    PageSwitch.manager,
    PageSwitch.caller,
    PageSwitch.leads,
    PageSwitch.callhistory,
    PageSwitch.reports,
    PageSwitch.configuration,
  ];
  setworkpage(String value, {bool isback = false}) {
    // if (pagenames.contains(value)) {
    //   // selectedindex.value = pagenames.indexWhere((element) => element == value);
    // }
    onpagechange(value);

    if (isback) {
      if (pagehistory.length >= 2) {
        pagehistory.removeLast();
        workwidgetname.value = pagehistory.last;
      } else if (pagehistory.length == 1) {
        workwidgetname.value = pagehistory.last;
      }
      if (drawertbs.contains(pagehistory.last)) {
        Get.find<MyDrawerControll>().selectedpage.value = pagehistory.last;
      }
    } else {
      workwidgetname.value = value;
      pagehistory.add(value);
    }
  }

  onpagechange(String value) {
    Get.find<Appbarcontroller>().searchbarctrl.text = '';
    Get.find<Appbarcontroller>().searchtext.value = '';
    Get.find<Appbarcontroller>().hidealloption();
    FocusScope.of(context).unfocus();
  }

  callerfulldetailopen({
    required String userid,
    required String compid,
  }) {
    Get.find<CallerWorkReportWebCtrl>().compid = compid;
    Get.find<CallerWorkReportWebCtrl>().userid = userid;
    setworkpage(PageSwitch.callerfulldetails);
  }

  onpageload() {
    workwidgetname.value = 'Dashboard';
    // Get.find<MyDrawerControll>().onloadpage();
    Get.find<Appbarcontroller>().onloadpage();
  }
}
