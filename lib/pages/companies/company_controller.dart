import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/search_filter.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/newcompany_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart' as http;

class CompanyPageCtrl extends GetxController {
  var pagetitelshow = 'Create New Company'.obs;
  var selectedstatus = 'Company Status'.obs;
  var selecteddate = DateTime.now().obs;
  var selecteddateshow = 'Activation Date'.obs;
  var sendSms = false.obs;
  var sendMail = false.obs;
  var isloadingdata = false.obs;
  var newcompanyDetails = NewCompanyModel();
  var buttonstate = ButtonState.idle.obs;
  var companynamectrl = TextEditingController();
  var emailctrl = TextEditingController();
  var mobilectrl = TextEditingController();
  var altmobilectrl = TextEditingController();
  var counttyctrl = TextEditingController();
  var statectrl = TextEditingController();
  var cityctrl = TextEditingController();
  var maxresponsectrl = TextEditingController();
  var maxdepartctrl = TextEditingController();
  var maxmanagerctrl = TextEditingController();
  var maxtelecallerctrl = TextEditingController();
  var compprefixctrl = TextEditingController();
  var allcompaniesList = <NewCompanyModel>[].obs;
  var showcompaniesList = <NewCompanyModel>[].obs;

  onPageOpen({NewCompanyModel? editdata}) {
    if (editdata == null) {
      sendSms.value = false;
      sendMail.value = false;
      pagetitelshow.value = 'Create New Company';
      selectedstatus.value = 'Company Status';
      newcompanyDetails = NewCompanyModel();
      companynamectrl.text = '';
      emailctrl.text = '';
      mobilectrl.text = '';
      altmobilectrl.text = '';
      counttyctrl.text = '';
      statectrl.text = '';
      cityctrl.text = '';
      maxresponsectrl.text = '';
      maxdepartctrl.text = '';
      maxmanagerctrl.text = '';
      maxtelecallerctrl.text = '';
      compprefixctrl.text = '';
      selecteddateshow.value = 'Activation Date';
      selecteddate.value = DateTime.now();
    } else {
      pagetitelshow.value = 'Edit Company';
      sendSms.value = editdata.smsEnable == '1';
      sendMail.value = editdata.mailEnable == '';
      selectedstatus.value = editdata.compStatus;
      newcompanyDetails = editdata;
      companynamectrl.text = editdata.compName;
      emailctrl.text = editdata.compEmail;
      mobilectrl.text = editdata.compMobile;
      altmobilectrl.text = editdata.compAltMobile;
      counttyctrl.text = editdata.country;
      statectrl.text = editdata.state;
      cityctrl.text = editdata.city;
      maxresponsectrl.text = editdata.maxResponses;
      maxdepartctrl.text = editdata.maxDeparts;
      maxmanagerctrl.text = editdata.maxManagers;
      maxtelecallerctrl.text = editdata.maxTelecallers;
      compprefixctrl.text = editdata.compPrefix;
      selecteddateshow.value = editdata.activateDate;
      selecteddate.value = DateTime.now();
    }
  }

  getCompanieslist({
    Map? filterdata,
  }) async {
    isloadingdata.value = true;
    filterdata ??= {
      "Isfilter": false,
    };
    var body = {
      "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "UserId": Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
      // "LastUpdate": lastupdatetime,
      // "FromDate": fromdate.value.toString(),
      // "ToDate": todate.value.toString(),
      ...filterdata,
    };

    allcompaniesList.clear();
    try {
      String _url = mainurl + '/company/getcompniesList.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['Status'] == true) {
          allcompaniesList.value = List<NewCompanyModel>.from(
              data['ResultData'].map((x) => NewCompanyModel.fromJson(x)));
          showcompaniesList.value = allcompaniesList;

          isloadingdata.value = false;
        } else {
          showcompaniesList.clear();
          isloadingdata.value = false;
        }
      }
    } catch (e) {
      showcompaniesList.clear();
      allcompaniesList.clear();
      debugPrint('getCompanieslist :$e');
      isloadingdata.value = false;
    }
  }

  deleteonecompany({required tableid}) async {
    isloadingdata.value = true;
    var body = {
      "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      "UserId": Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      "TableID": tableid,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      String _url = mainurl + '/company/deletacompany.php';
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          showsnackbar(titel: 'Success !!!', detail: data['Msj']);
          getCompanieslist();
          isloadingdata.value = false;
        } else {
          showsnackbar(titel: 'Failed !!!', detail: data['Msj']);
          isloadingdata.value = false;
        }
      }
    } catch (e) {
      debugPrint('deleteonecompany :$e');
      isloadingdata.value = false;
    }
  }

  changebtnstate(int index) async {
    if (index <= 3) {
      buttonstate.value = states[index];
      if (index >= 2) {
        await Future.delayed(const Duration(seconds: 3));
        buttonstate.value = states[0];
      }
    }
  }

  onsearchvalue(String value) {
    if (value.length >= 2) {
      List<int> _indexes = makeserachindata(
        value: value,
        dataList: [...allcompaniesList.map((element) => element.toJson())],
      );
      showcompaniesList.value =
          _indexes.map((e) => allcompaniesList[e]).toList();
    } else {
      showcompaniesList.value = allcompaniesList;
    }
  }
}

List<ButtonState> states = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail,
];
