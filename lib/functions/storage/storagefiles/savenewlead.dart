import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/storage/storagekeys.dart';
import 'package:callingpanel/models/leads/leadfulldetail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

saveleadlocally({
  LeadFullDetail? onedata,
  bool? iscalled,
  bool? havedata,
  String? callstarttime,
  String? callendtime,
}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String userId =
      Get.find<LogeduserControll>().logeduserdetail.value.logeduserId;
  if (havedata != null) {
    pref.setBool(StorageKeys.havenewleaddata + userId, havedata);
  }

  if (iscalled != null) {
    pref.setBool(StorageKeys.iscalledtolead + userId, iscalled);
  }

  if (onedata != null) {
    pref.setString(StorageKeys.leadid, onedata.tableId ?? '');
    pref.setString(StorageKeys.leadfullname, onedata.fullName ?? '');
    pref.setString(StorageKeys.leadmobile, onedata.mobile ?? '');
    pref.setString(StorageKeys.leadaltmobile, onedata.altMobile ?? '');
    pref.setString(StorageKeys.leadmail, onedata.email ?? '');
    pref.setString(StorageKeys.leadprofile, onedata.profile ?? '');
    pref.setString(StorageKeys.leadcountry, onedata.country ?? '');
    pref.setString(StorageKeys.leadstate, onedata.state ?? '');
    pref.setString(StorageKeys.leadcity, onedata.city ?? '');
    pref.setString(StorageKeys.leadIssuedToId,
        Get.find<LogeduserControll>().logeduserdetail.value.logeduserId);
    pref.setString(StorageKeys.leaddepart, onedata.departments ?? '');
  }

  if (callstarttime != null) {
    pref.setString(StorageKeys.callstarttime, callstarttime);
  }
  if (callendtime != null) {
    pref.setString(StorageKeys.callendtime, callendtime);
  }
}

Future<Map<String, dynamic>> getleadlocally() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String userId =
      Get.find<LogeduserControll>().logeduserdetail.value.logeduserId;
  var data = {
    StorageKeys.havenewleaddata + userId:
        pref.getBool(StorageKeys.havenewleaddata + userId) ?? false,
    StorageKeys.iscalledtolead + userId:
        pref.getBool(StorageKeys.iscalledtolead + userId) ?? false,
    StorageKeys.leadid: pref.getString(StorageKeys.leadid) ?? '',
    StorageKeys.leadfullname: pref.getString(StorageKeys.leadfullname) ?? '',
    StorageKeys.leadmobile: pref.getString(StorageKeys.leadmobile) ?? '',
    StorageKeys.leadaltmobile: pref.getString(StorageKeys.leadaltmobile) ?? '',
    StorageKeys.leadmail: pref.getString(StorageKeys.leadmail) ?? '',
    StorageKeys.leadprofile: pref.getString(StorageKeys.leadprofile) ?? '',
    StorageKeys.leadcountry: pref.getString(StorageKeys.leadcountry) ?? '',
    StorageKeys.leadstate: pref.getString(StorageKeys.leadstate) ?? '',
    StorageKeys.leadcity: pref.getString(StorageKeys.leadcity) ?? '',
    StorageKeys.leaddepart: pref.getString(StorageKeys.leaddepart) ?? '',
    StorageKeys.callstarttime:
        pref.getString(StorageKeys.callstarttime) ?? 'NA',
    StorageKeys.callendtime: pref.getString(StorageKeys.callendtime) ?? 'NA',
  };
  return data;
}
