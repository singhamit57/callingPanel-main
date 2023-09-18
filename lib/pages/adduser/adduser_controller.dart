// ignore_for_file: unrelated_type_equality_checks

import 'package:callingpanel/models/manager/addedituser_model.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:progress_state_button/progress_button.dart';

class AddEditUserController extends GetxController {
  var pagetitel = 'Create New User'.obs;
  var selectedpost = 'Select Post'.obs;
  var selectedgender = 'Select Gender'.obs;
  var selecteddepart = 'Select Department'.obs;
  var selectedstatus = 'User Status'.obs;
  var operation = "";
  NewUserModel userdata = NewUserModel();

  var buttonstate = ButtonState.idle.obs;
  var companyidctrl = TextEditingController();
  var companynamectrl = TextEditingController();
  // var usridctrl = TextEditingController();
  var passwrodctrl = TextEditingController();
  var usernamectrl = TextEditingController();

  var mobilectrl = TextEditingController();
  var altmobilectrl = TextEditingController();
  var emailctrl = TextEditingController();
  var counttyctrl = TextEditingController();
  var statectrl = TextEditingController();
  var cityctrl = TextEditingController();
  // var pincodectrl = TextEditingController();
  var banknamectrl = TextEditingController();
  var accountctrl = TextEditingController();
  var ifsctrl = TextEditingController();
  var datacodectrl = TextEditingController();

  updatepost(String value) {
    selectedpost.value = value;
    addEditDepartmetn.value = false;
    addEditResponse.value = false;
    addEditUser.value = false;
    addEditLead.value = false;
    deleteUpdateLead.value = false;
    viewReports.value = false;
    downloadReport.value = false;
    updateReport.value = false;
    makeCall.value = false;
    sendSms.value = false;
    sendMail.value = false;

    if (pagetitel.value.contains("Create New")) {
      if (value == "Select Post") {
        pagetitel.value = "Create New User";
      } else {
        pagetitel.value = "Create New User".replaceAll("User", value);
      }
    } else {
      if (value == "Select Post") {
        pagetitel.value = "Edit User";
      } else {
        pagetitel.value = "Edit User".replaceAll("User", value);
      }
    }
  }

  onnewuser() {
    pagetitel.value = 'Create New User';
    selectedgender.value = 'Select Gender';
    selectedpost.value = 'Select Post';
    selecteddepart.value = 'Select Department';

    usernamectrl.text = '';
    selectedstatus.value = 'User Status';
    companyidctrl.text = '';
    companynamectrl.text = '';
    mobilectrl.text = '';
    altmobilectrl.text = '';
    emailctrl.text = '';
    counttyctrl.text = '';
    statectrl.text = '';
    cityctrl.text = '';
    banknamectrl.text = '';
    accountctrl.text = '';
    ifsctrl.text = '';
    passwrodctrl.text = '';
    datacodectrl.text = '';
    if (operation == "Addnewadmin") {
      selectedpost.value = "Admin";
      pagetitel.value = "Create New Admin";
    }
    if (operation == "Addnewmanager") {
      selectedpost.value = "Manager";
      pagetitel.value = "Create New Manager";
    }
    if (operation == "Addnewtelecaller") {
      selectedpost.value = "Telecaller";
      pagetitel.value = "Create New Telecaller";
    }

    updatepost(selectedpost.value);
  }

  edituser({required NewUserModel edituser}) {
    userdata = edituser;

    companyidctrl.text = edituser.companyId;
    companynamectrl.text = edituser.companyName;
    userdata.preTableId = edituser.preTableId;
    userdata.isnewuser = '1';
    usernamectrl.text = edituser.fullName;
    selectedstatus.value = edituser.userstatus;
    mobilectrl.text = edituser.mobile;
    altmobilectrl.text = edituser.altMobile;
    emailctrl.text = edituser.email;
    counttyctrl.text = edituser.country;
    statectrl.text = edituser.state;
    cityctrl.text = edituser.city;
    banknamectrl.text = edituser.bankName;
    accountctrl.text = edituser.accountNumber;
    ifsctrl.text = edituser.ifsc;
    passwrodctrl.text = edituser.password;
    datacodectrl.text = edituser.datacode;
    selectedpost.value = edituser.designation;
    selectedgender.value = edituser.gender;
    selecteddepart.value = edituser.department;
    addEditDepartmetn.value = edituser.addEditDepartmetn == '1';
    addEditResponse.value = edituser.addEditResponse == '1';
    addEditUser.value = edituser.addEditUser == '1';
    addEditLead.value = edituser.addEditLead == '1';
    deleteUpdateLead.value = edituser.deleteUpdateLead == '1';
    viewReports.value = edituser.viewReports == '1';
    downloadReport.value = edituser.downloadReport == '1';
    updateReport.value = edituser.updateReport == '1';
    makeCall.value = edituser.makeCall == '1';
    sendSms.value = edituser.sendSms == '1';
    sendMail.value = edituser.sendMail == '1';
    pagetitel.value =
        'Edit ${selectedpost.value}'.replaceAll("Select Post", "User");
  }

  isselectmanager() {
    return selectedpost == 'Manager' ? true : false;
  }

  isselecttelecaller() {
    return selectedpost == 'Telecaller' ? true : false;
  }

  var isnewform = false.obs;
  // var edituserdata = NewUserModel().obs;
  var addEditDepartmetn = false.obs;
  var addEditResponse = false.obs;
  var addEditUser = false.obs;
  var addEditLead = false.obs;
  var deleteUpdateLead = false.obs;
  var viewReports = false.obs;
  var downloadReport = false.obs;
  var updateReport = false.obs;
  var makeCall = false.obs;
  var sendSms = false.obs;
  var sendMail = false.obs;

  changebtnstate(int index) async {
    if (index <= 3) {
      buttonstate.value = states[index];
      if (index >= 2) {
        await Future.delayed(const Duration(seconds: 3));
        buttonstate.value = states[0];
      }
    }
  }
}

List<ButtonState> states = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail,
];
