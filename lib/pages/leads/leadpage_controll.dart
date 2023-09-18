import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/api_resultmsj.dart';
import 'package:callingpanel/functions/donload_file.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/leads/leadfulldetail_model.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

DateTime nowdatetime = DateTime.now();
WorkPageController? workPageController;

class LeadPageCtrl extends GetxService {
  @override
  void onInit() {
    filtercategory = '';
    workPageController = Get.find<WorkPageController>();
    super.onInit();
  }

  openbysidebar() {
    pagetitel.value = 'Leads';
    Get.find<Appbarcontroller>().newleadvisible.value = true;
    getleadlist(context: workPageController!.context, pagenumber: 0);
  }

  var leaddetailList = <LeadFullDetail>[].obs;
  var allleaddetailList = <LeadFullDetail>[].obs;
  // var allleadcards = <Widget>[].obs;
  var isloadingdata = false.obs;
  var lastdatabody = {};
  var pagetitel = 'Leads'.obs;
  // var prefillterdata = null;
  var previousbody = {};
  var filtercategory = '';
  // var searchinput = '';
  var totalavaildata = 0;
  var totalavailpage = 0;
  var nexpagenumber = 0;
  var fromdate =
      DateTime(nowdatetime.year, nowdatetime.month, nowdatetime.day - 15).obs;
  var todate =
      DateTime(nowdatetime.year, nowdatetime.month, nowdatetime.day).obs;

  changedatetime({
    required DateTime setfromdate,
    required DateTime settodate,
  }) {
    fromdate.value = setfromdate;
    todate.value = settodate;
    getleadlist(context: workPageController!.context, pagenumber: 0);
  }

  getleadlist({
    BuildContext? context,
    required int pagenumber,
    String searchinput = '',
    bool isserchingbyinput = false,
  }) async {
    if (pagenumber == 0) {
      isloadingdata.value = true;
      allleaddetailList.clear();
      leaddetailList.clear();
    }

    var body = {
      "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "UserId": Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      "PageNumber": pagenumber,
      "FromDate": fromdate.value.toString(),
      "ToDate": todate.value.toString(),
      "SearchInput": searchinput,
      "Isserchingbyinput": isserchingbyinput,
      "Isfilter": pagetitel.value != 'Leads',
      "FilterName": filtercategory,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    if (pagenumber == 0) {
      previousbody = body;
    } else {
      body = {...previousbody, "PageNumber": pagenumber};
    }
    try {
      String _url = mainurl + '/leaddatabase/newLeaddetailList.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['Status'] == true) {
          final gotnewdata = List<LeadFullDetail>.from(
              data['ResultData'].map((x) => LeadFullDetail.fromJson(x)));
          allleaddetailList.value = [...allleaddetailList, ...gotnewdata];
          leaddetailList.value = allleaddetailList;
          totalavailpage = data['Msj']['TotalAvlPages'];
          totalavaildata = data['Msj']['TotalAvlData'];
          isloadingdata.value = false;
        } else {
          leaddetailList.clear();
          isloadingdata.value = false;
        }
      } else {
        showApiResultMsj(
          apidata: '',
        );
      }
    } catch (e) {
      leaddetailList.clear();
      debugPrint('getleadlist :$e');
    }
    isloadingdata.value = false;
    lastdatabody = body;
    nexpagenumber = pagenumber + 1;
  }

  deleteonelead({required tableid}) async {
    isloadingdata.value = true;
    var body = {
      "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "UserId": Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      "TableID": tableid,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      String _url = mainurl + '/leaddatabase/deleteonelead.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          showsnackbar(titel: 'Success !!!', detail: data['Msj']);
          allleaddetailList
              .removeWhere((element) => element.tableId == tableid);
          leaddetailList.removeWhere((element) => element.tableId == tableid);
          // getleadlist(context: workPageController!.context, pagenumber: 0);.
          isloadingdata.value = false;
        } else {
          showsnackbar(titel: 'Failed !!!', detail: data['Msj']);
          isloadingdata.value = false;
        }
      }
    } catch (e) {
      debugPrint('deleteonelead :$e');
      isloadingdata.value = false;
    }
    return allleaddetailList;
  }

  deleteMultiplelead({
    required List<int> indexes,
    required bool isallselected,
  }) async {
    isloadingdata.value = true;
    var body = {
      ...previousbody,
      "AllSelectForDelete": isallselected,
      "SelectedLeadList": [
        ...indexes.map((e) => leaddetailList[e].tableId),
      ],
    };
    // print(body);
    // return;
    try {
      String _url = mainurl + '/leaddatabase/deletemultiplelead.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        isloadingdata.value = false;
        // print(data);
        if (data['Status'] == true) {
          getleadlist(pagenumber: 0);
          showsnackbar(titel: 'Success !!!', detail: data['Msj']);
        } else {
          showsnackbar(titel: 'Failed !!!', detail: data['Msj']);
        }
      }
    } catch (e) {
      debugPrint('deleteonelead :$e');
      isloadingdata.value = false;
    }
  }

  getsearchresult({
    required String value,
  }) async {
    getleadlist(pagenumber: 0, searchinput: value, isserchingbyinput: true);
  }

  downloadFile() async {
    String _url = mainurl + '/leaddatabase/newLeaddetailList.php';
    var body = {...previousbody, "operation": "download"};
    if (isloadingdata.value) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please wait...');
      return;
    }
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          var filepath = data['Msj'];
          downloadFileByUrl(url: filepath);
        } else {
          showsnackbar(
              titel: 'Failed !!!', detail: 'Unable to generate report....');
        }
      } else {
        showsnackbar(titel: 'Failed !!!', detail: 'Server not respond....');
      }
    } catch (e) {
      debugPrint("downloadFile : $e");
      showsnackbar(titel: 'Failed !!!', detail: 'Something is wrong....');
    }
  }
}


/*

getsearchresult({
    required String value,
  }) async {
    isloadingdata.value = true;
    String _value = value.toLowerCase();
    List<bool> _isfind = <bool>[];
    List<LeadFullDetail> locallist = [];
    if (value.length >= 3) {
      locallist = allleaddetailList.where((element) {
        _isfind.clear();
        var data = element.toJson();
        data.forEach((key, keyvalue) {
          if (keyvalue.toString().toLowerCase().contains(_value)) {}
          _isfind.add(keyvalue.toString().toLowerCase().contains(_value));
        });

        return _isfind.contains(true);
      }).toList();

      leaddetailList.value = locallist;
      await Future.delayed(Duration(milliseconds: 800));
    } else {
      leaddetailList.value = allleaddetailList;
    }

    isloadingdata.value = false;
    _isfind.clear();
  }
*/