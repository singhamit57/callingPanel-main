import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/pages/uploaddata/uploaddata_model.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:get/get.dart';

class AddDataControll extends GetxController {
  @override
  void onInit() {
    onpageload();
    super.onInit();
  }

  var leadPageTitel = 'Create Lead'.obs;
  var loadingbtnlable = 'Please wait...'.obs;
  var selectedDepart = ''.obs;
  var departmetns = <String>['Select Department', 'Sales', 'Information'].obs;
  var totaldata = 0;
  var uploadeddata = 0;
  var uploadedpercent = 0.0.obs;
  var datacode = '';
  List<UploaddataModel> updatalist = [];
  UploaddataModel addeditonedata = UploaddataModel();

  ///inpercengate
  var issearching = false.obs;
  var buttonstate = ButtonState.idle.obs;

  TextEditingController namectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController mobilectrl = TextEditingController();
  TextEditingController altmobilectrl = TextEditingController();
  TextEditingController profilectrl = TextEditingController();
  TextEditingController datacodectrl = TextEditingController();
  TextEditingController countryctrl = TextEditingController();
  TextEditingController statectrl = TextEditingController();
  TextEditingController cityctrl = TextEditingController();

  onpageload({
    UploaddataModel? editdata,
  }) {
    if (editdata == null) {
      leadPageTitel.value = 'Create Lead';
      namectrl.text = '';
      emailctrl.text = '';
      mobilectrl.text = '';
      altmobilectrl.text = '';
      profilectrl.text = '';
      datacodectrl.text = '';
      countryctrl.text = '';
      statectrl.text = '';
      cityctrl.text = '';
    } else {
      leadPageTitel.value = 'Edit Lead';
      addeditonedata = editdata;
      namectrl.text = editdata.fullName;
      emailctrl.text = editdata.emailId;
      mobilectrl.text = editdata.mobile;
      altmobilectrl.text = editdata.altMobile;
      profilectrl.text = editdata.profile;
      datacodectrl.text = editdata.datacode;
      countryctrl.text = editdata.country;
      statectrl.text = editdata.state;
      cityctrl.text = editdata.city;
      selectedDepart.value = editdata.department;
    }

    updatalist.clear();
  }

  insertdepartment() {
    departmetns.clear();
    departmetns.add('Select Department');
    Get.find<LogeduserControll>().comDepartmentList.forEach((element) {
      if (element.department != null) {
        departmetns.add(element.department!);
      }
    });
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

  updateupload(int value) {
    if ((uploadeddata + value) < totaldata) {
      uploadeddata = uploadeddata + value;
      uploadedpercent.value = uploadeddata / totaldata;
    }
  }
}

List<ButtonState> states = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail,
];
