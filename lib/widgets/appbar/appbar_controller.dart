import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/functions/donload_file.dart';
import 'package:callingpanel/pages/admin/admin_controller.dart';
import 'package:callingpanel/pages/callerworkreport/callerworkreport_controller.dart';
import 'package:callingpanel/pages/callhistory/callhistory_controller.dart';
import 'package:callingpanel/pages/companies/company_controller.dart';
import 'package:callingpanel/pages/leads/leadpage_controll.dart';
import 'package:callingpanel/pages/manager/mager_controller.dart';
import 'package:callingpanel/pages/telecaller/telecaller_controller.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

WorkPageController? workPageController;
CallHistoryWebCtrl? callHistoryWebCtrl;
CallerWorkReportWebCtrl? callerWorkReportWebCtrl;
LogeduserControll? logeduserControll;
String _comp = "";

class Appbarcontroller extends GetxService {
  onloadpage() {
    logeduserControll = Get.find<LogeduserControll>();
    _comp = logeduserControll!.logeduserdetail.value.compName;
    appbarheading.value = _comp;
  }

  @override
  void onReady() {
    workPageController = Get.find<WorkPageController>();
    callHistoryWebCtrl = Get.find<CallHistoryWebCtrl>();
    callerWorkReportWebCtrl = Get.find<CallerWorkReportWebCtrl>();

    super.onReady();
  }

  var appbarheading = Constants.appname.obs;
  var hovericonname = ''.obs;

  ///Visibility Start
  var searchvisible = false.obs;
  var addvisible = false.obs;
  var daterangevisible = false.obs;
  var datevisible = false.obs;
  var uploadvisible = false.obs;
  var downloadvisible = false.obs;
  var newcompanyvisible = false.obs;
  var newleadvisible = false.obs;

  ///Visibility End
  var searchtext = "".obs;
  var iconsize = 24.0.obs;
  var textsize = 12.0.obs;
  var selecteddate = DateTime.now().obs;

  ///Tool tip
  var downloadTip = ''.obs;

  DateTime getfromdate({DateTime? setfromdate}) {
    var fromdate =
        DateTime(nowdatetime.year, nowdatetime.month, nowdatetime.day - 15);
    if (setfromdate != null) {
      fromdate = setfromdate;
    }
    return fromdate;
  }

  DateTime gettodate({DateTime? settodate}) {
    var todate = DateTime(nowdatetime.year, nowdatetime.month, nowdatetime.day);
    if (settodate != null) {
      todate = settodate;
    }
    return todate;
  }

  var searchbarctrl = TextEditingController();

  onchangedaterange({
    required DateTime setfromdate,
    required DateTime settodate,
  }) {
    String pagename = workPageController!.workwidgetname.value;
    if (pagename == PageSwitch.leads) {
      Get.find<LeadPageCtrl>()
          .changedatetime(setfromdate: setfromdate, settodate: settodate);
    }
    if (pagename == PageSwitch.callhistory) {
      callHistoryWebCtrl!.fromdate = setfromdate;
      callHistoryWebCtrl!.todate = settodate;
      callHistoryWebCtrl!.getreponsehistryweb(pagenumber: 0);
    }
    if (pagename == PageSwitch.callerfulldetails) {
      callerWorkReportWebCtrl!
          .ondaterangechange(setfromdate: setfromdate, settodate: settodate);
    }
  }

  downloadbuttonclick() async {
    if (PageSwitch.newlead == workPageController!.workwidgetname.value) {
      var url = mainurl + "leadfile.xlsx";
      downloadFileByUrl(url: url);
      // try {

      //   if (Platform.isWindows) {
      //     launch.launch(url);
      //   } else {
      //     html.AnchorElement anchorElement = html.AnchorElement(href: url);
      //     anchorElement.download = url;
      //     anchorElement.click();
      //   }
      // } catch (e) {
      //   debugPrint("downloadbuttonclick : $e");
      //   showsnackbar(titel: 'Failed !!!', detail: 'Something is worng...');
      // }
    }

    if (workPageController!.workwidgetname.value == PageSwitch.leads) {
      Get.find<LeadPageCtrl>().downloadFile();
    }

    if (workPageController!.workwidgetname.value == PageSwitch.callhistory) {
      Get.find<CallHistoryWebCtrl>().downloadFile();
    }
  }

  changeinsearch(String value) {
    if (searchvisible.value) {
      String pagename = workPageController!.workwidgetname.value;
      EasyDebounce.debounce('Appbarsearch', const Duration(milliseconds: 400),
          () {
        if (pagename == PageSwitch.leads) {
          Get.find<LeadPageCtrl>().getsearchresult(value: value);
        }
        if (pagename == PageSwitch.manager) {
          Get.find<MangerListCtrl>().onsearchvalue(value);
        }
        if (pagename == PageSwitch.caller) {
          Get.find<TelecallerListCtrl>().onsearchvalue(value);
        }
        if (pagename == PageSwitch.callhistory) {
          callHistoryWebCtrl!.getreponsehistryweb(
              pagenumber: 0, value: value, isserchingbyinput: true);
        }
        if (pagename == PageSwitch.companies) {
          Get.find<CompanyPageCtrl>().onsearchvalue(value);
        }
        if (pagename == PageSwitch.admins) {
          Get.find<AdminPageWebCtrl>().onsearchvalue(value);
        }
      });
    }
  }

  hidealloption() {
    searchvisible.value = false;
    addvisible.value = false;
    daterangevisible.value = false;
    datevisible.value = false;
    uploadvisible.value = false;
    downloadvisible.value = false;
    newcompanyvisible.value = false;
    newleadvisible.value = false;
  }
}
