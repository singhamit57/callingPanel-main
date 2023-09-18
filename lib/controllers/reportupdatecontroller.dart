import 'dart:async';
import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_loading.dart';
import 'package:callingpanel/models/updatehistory_model.dart';
import 'package:callingpanel/pages/admin/admin_controller.dart';
import 'package:callingpanel/pages/companies/company_controller.dart';
import 'package:callingpanel/pages/leads/leadpage_controll.dart';
import 'package:callingpanel/pages/manager/mager_controller.dart';
import 'package:callingpanel/pages/reports/report_controller.dart';
import 'package:callingpanel/pages/telecaller/telecaller_controller.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

MangerListCtrl? managerlistctrl;
LeadPageCtrl? leadpagectrl;
TelecallerListCtrl? telecallerListCtrl;
ReportPageCtrl? reportPageCtrl;
LogeduserControll? logeduserControll;
WorkPageController? workPageController;
CompanyPageCtrl? addeditcompany;
AdminPageWebCtrl? adminPageWebCtrl;

class ReportUpdateCtrl extends GetxService {
  initcontollers() {
    managerlistctrl = Get.find<MangerListCtrl>();
    telecallerListCtrl = Get.find<TelecallerListCtrl>();
    leadpagectrl = Get.find<LeadPageCtrl>();
    reportPageCtrl = Get.find<ReportPageCtrl>();
    logeduserControll = Get.find<LogeduserControll>();
    workPageController = Get.find<WorkPageController>();
    addeditcompany = Get.find<CompanyPageCtrl>();
    adminPageWebCtrl = Get.find<AdminPageWebCtrl>();
  }

  var lastupdatehistory = UpdateHistoryModel();
  var checkreport = true;
  var companyid = jsonEncode({
    "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
    "Code": "lasdfndasoip6332pojwer",
    ...Get.find<LogeduserControll>().logedUserdetailMap(),
  });

  var uri = Uri.parse(mainurl + '/getupdateStamp.php');

  startcheckreport() async {
    initcontollers();
    await firstreportcheck();
    await checkreportupdate(isfirsttime: true);
    await Future.delayed(const Duration(seconds: 10));
    while (checkreport) {
      await checkreportupdate(isfirsttime: false);
      //  print(DateTime.now());
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  firstreportcheck() async {
    showloadingdilogue(context: workPageController!.context);
    await managerlistctrl!.getrecords();
    await telecallerListCtrl!.getrecords();
    // await leadpagectrl!.getleadlist(context: workPageController!.context);
    await reportPageCtrl!.getreportcarddetails();
    await addeditcompany!.getCompanieslist();
    await adminPageWebCtrl!.getrecords();
    Get.back();
  }

  checkreportupdate({
    required bool isfirsttime,
  }) async {
    try {
      http.Response response = await http.post(uri, body: companyid);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data);
        if (data['Status'] == true) {
          final newdata = UpdateHistoryModel.fromJson(data['ResultData']);
          if (isfirsttime) {
            lastupdatehistory = newdata;
          } else {
            isreportupdated(newdata: newdata);
          }
        }
      }
    } catch (e) {
      debugPrint("first report check : $e ");
    }
  }

  isreportupdated({
    required UpdateHistoryModel newdata,
  }) async {
    if (checkchanges(newdata.userDetails, lastupdatehistory.userDetails)) {
      await managerlistctrl!.getrecords();
      await telecallerListCtrl!.getrecords();
      await await adminPageWebCtrl!.getrecords();
    }
    if (checkchanges(newdata.leadsDataBase, lastupdatehistory.leadsDataBase) ||
        checkchanges(newdata.leadResponse, lastupdatehistory.leadResponse)) {
      await reportPageCtrl!.getreportcarddetails();
    }
    if (checkchanges(
            newdata.companiesDetails, lastupdatehistory.companiesDetails) &&
        logeduserControll!.logeduserdetail.value.logeduserPost ==
            'Super Admin') {
      await addeditcompany!.getCompanieslist();
    }

    lastupdatehistory = newdata;
  }
}

bool checkchanges(
  String newvalue,
  String oldvalue,
) {
  bool _ischange = false;
  if (newvalue != '0' && newvalue != oldvalue) {
    _ischange = true;
  }
  return _ischange;
}
