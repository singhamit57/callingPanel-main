import 'dart:convert';
import 'package:callingpanel/constants/circle_avtar.dart';
import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/functions/storage/storagefiles/savenewlead.dart';
import 'package:callingpanel/functions/storage/storagekeys.dart';
import 'package:callingpanel/models/leads/leadfulldetail_model.dart';
import 'package:callingpanel/pages/uploaddata/uploaddata_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MobileNewDataCtrl extends GetxService {
  @override
  void onReady() {
    getnewdata();
    getfollowlist();
    super.onReady();
  }

  var selecteddepartment = 'Any Department'.obs;
  var selectedlocation = 'Any Location'.obs;

  var shownewdta = LeadFullDetail().obs;
  var donthavedata = false.obs;
  var allfollowlist = <LeadFullDetail>[].obs;
  var followlistshow = <LeadFullDetail>[].obs;
  var leadcountry = '';
  var leadstate = '';
  var leadcity = '';
  var issearching = false.obs;
  var iscalledtolead = false.obs;
  // var searchbarctrl = TextEditingController();
  var searchtextctrl = TextEditingController();
  var totaldata = 0;
  var uploadeddata = 0;
  var uploadedpercent = 0.0.obs;
  List<UploaddataModel> updatalist = [];
  updateupload(int value) {
    if ((uploadeddata + value) < totaldata) {
      uploadeddata = uploadeddata + value;
      uploadedpercent.value = uploadeddata / totaldata;
    }
  }

  getnewdata() async {
    issearching.value = true;
    donthavedata.value = false;
    var predata = await getleadlocally();
    String userid =
        Get.find<LogeduserControll>().logeduserdetail.value.logeduserId;
    if (predata[StorageKeys.havenewleaddata + userid] &&
        predata[StorageKeys.iscalledtolead + userid]) {
      iscalledtolead.value = true;
      var _localdata = LeadFullDetail(
          tableId: predata[StorageKeys.leadid],
          fullName: predata[StorageKeys.leadfullname],
          mobile: predata[StorageKeys.leadmobile],
          altMobile: predata[StorageKeys.leadaltmobile],
          email: predata[StorageKeys.leadmail],
          profile: predata[StorageKeys.leadprofile],
          departments: predata[StorageKeys.leaddepart],
          country: predata[StorageKeys.leadcountry],
          state: predata[StorageKeys.leadstate],
          city: predata[StorageKeys.leadcity]);
      selecteddepartment.value =
          predata[StorageKeys.leaddepart] ?? 'Any Department';
      shownewdta.value = _localdata;

      issearching.value = false;
      showsnackbar(
          titel: 'Alert !!!', detail: 'Please submit pending lead response...');
      return;
    } else {
      iscalledtolead.value = false;
    }

    try {
      String url = mainurl + '/leaddatabase/issueonedata_app.php';
      var body = {
        "CompID": Get.find<LogeduserControll>().logeduserdetail.value.compId,
        "UserID":
            Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
        "isdepartfilter": selecteddepartment.value != 'Any Department',
        "islocationfilter": selectedlocation.value != 'Any Location',
        "Departfilter": selecteddepartment.value,
        "Country": leadcountry,
        "State": leadstate,
        "City": leadcity,
        'predata': shownewdta.value.tableId ?? '',
        ...Get.find<LogeduserControll>().logedUserdetailMap(),
      };

      http.Response response =
          await http.post(Uri.parse(url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          shownewdta.value = LeadFullDetail.fromJson(data['ResultData'][0]);
          iscalledtolead.value = false;
          // datatableid.value = shownewdta.value.tableId!;

        } else {
          iscalledtolead.value = false;
          donthavedata.value = true;
          if (data['ResultData'][0] != null) {
            shownewdta.value = LeadFullDetail.fromJson(data['ResultData'][0]);
          }
          showsnackbar(
              titel: 'Failed', detail: data['Msj'] ?? 'No Data available...');
        }
      }
    } catch (e) {
      iscalledtolead.value = false;
      debugPrint('new data : $e');
    }
    iscalledtolead.value = false;
    issearching.value = false;
  }

  getfollowlist() async {
    issearching.value = true;
    allfollowlist.clear();
    followlistshow.clear();
    String _url = mainurl + "/leaddatabase/follouplist_app.php";
    var body = {
      "CompID": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "UserID": Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['Status'] == true) {
          allfollowlist.value = List<LeadFullDetail>.from(
              data['ResultData'].map((x) => LeadFullDetail.fromJson(x)));

          if (avtarlist.length <= allfollowlist.length) {
            int _count = allfollowlist.length - avtarlist.length;
            int i = 0;
            _count = _count + 2;
            while (i < _count) {
              avtarlist.add(avtarlist[i]);
              i++;
            }
          }
          for (var i = 0; i < allfollowlist.length; i++) {
            allfollowlist[i].avtarpath = avtarlist[i];
          }

          followlistshow.value = allfollowlist;
        } else {}
      } else {}
    } catch (e) {
      debugPrint('follow $e');
    }
    issearching.value = false;
  }

  getsearchresult(String value, bool excatmatch) {
    if (value.length >= 3) {
      String _value = value.toLowerCase();
      List<LeadFullDetail> locallist = [];
      for (var element in allfollowlist) {
        var data = element.toJson();
        bool isfounded = false;
        data.forEach((key, value) {
          if (isfounded) return;
          if (excatmatch) {
            if (value.toString().toLowerCase() == _value) {
              locallist.add(element);

              isfounded = true;
            }
          } else {
            if (value.toString().toLowerCase().contains(_value)) {
              locallist.add(element);
              isfounded = true;
            }
          }
        });
      }
      followlistshow.value = locallist;
    } else {
      followlistshow.value = allfollowlist;
    }
  }

  String getfollowcount(String value) {
    int _count = 0;
    for (var element in allfollowlist) {
      if (element.lastPriority!.contains(value)) {
        _count++;
      }
    }

    return _count.toString();
  }
}
