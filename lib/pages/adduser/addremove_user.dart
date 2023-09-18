// ignore_for_file: unrelated_type_equality_checks, duplicate_ignore

import 'dart:convert';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/constants/validate_exp.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/functions/dio_request.dart';
import 'package:callingpanel/functions/getcompanybyid.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/mini_widgets.dart/animated_button.dart';
import 'package:callingpanel/models/manager/addedituser_model.dart';
import 'package:callingpanel/pages/adduser/adduser_controller.dart';
import 'package:callingpanel/pages/admin/admin_controller.dart';
import 'package:callingpanel/pages/manager/mager_controller.dart';
import 'package:callingpanel/pages/telecaller/telecaller_controller.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:callingpanel/widgets/reuseable/csc_pickerwidget.dart';
import 'package:callingpanel/widgets/reuseable/mytext_field.dart';
import 'package:callingpanel/widgets/reuseable/str_dropdown.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:velocity_x/velocity_x.dart';

List<String> genderlist = ['Select Gender', 'Male', 'Female', 'Other'];
List<String> userstatuslist = ['User Status', 'Active', 'Block'];
String selectedgender = genderlist[0];

class AddRemoveUsersPage extends StatefulWidget {
  final String? operation;
  const AddRemoveUsersPage({Key? key, this.operation}) : super(key: key);

  @override
  _AddRemoveUsersPageState createState() => _AddRemoveUsersPageState();
}

AddEditUserController? addusercontroller;
LogeduserControll? logeduserctrl;
ScrollController scrollController = ScrollController();

class _AddRemoveUsersPageState extends State<AddRemoveUsersPage> {
  @override
  void initState() {
    addusercontroller = Get.find<AddEditUserController>();
    logeduserctrl = Get.find<LogeduserControll>();

    // onnewuser();
    super.initState();
  }

  @override
  void dispose() {
    addusercontroller!.selectedpost.value = 'Select Post';
    addusercontroller!.pagetitel.value = 'Create New User';
    // addusercontroller!.onnewuser();
    addusercontroller!.operation = "";
    addusercontroller!.userdata = NewUserModel();
    super.dispose();
  }

  // ignore: duplicate_ignore
  bool validateform() {
    if (Get.find<LogeduserControll>().showcompoption.value) {
      if (addusercontroller!.companyidctrl.text.length < 3) {
        showsnackbar(titel: 'Alert !!!', detail: 'Please enter company id...');
        return false;
      }
      if (addusercontroller!.companynamectrl.text.length < 3) {
        showsnackbar(
            titel: 'Alert !!!', detail: 'Please enter valid company id...');
        return false;
      }
    }

    if (addusercontroller!.usernamectrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter full name...');
      return false;
    }

    if (addusercontroller!.mobilectrl.text.length < 4) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter mobile number...');
      return false;
    }
    if (addusercontroller!.emailctrl.text.isNotEmpty &&
        !addusercontroller!.emailctrl.text.isEmail) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter valid email...');
      return false;
    }
    if (addusercontroller!.counttyctrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter country name...');
      return false;
    }
    if (addusercontroller!.statectrl.text.length < 2) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter state name...');
      return false;
    }
    if (addusercontroller!.cityctrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter city name...');
      return false;
    }
    //User Status
    // ignore: unrelated_type_equality_checks
    if (addusercontroller!.selectedstatus == 'User Status') {
      showsnackbar(titel: 'Alert !!!', detail: 'Please select user status...');
      return false;
    }
    if (addusercontroller!.selectedgender == genderlist[0]) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please select gender...');
      return false;
    }
    if (addusercontroller!.passwrodctrl.text.length < 4) {
      showsnackbar(
          titel: 'Alert !!!',
          detail: 'Please make at least 4 digit password...');
      return false;
    }
    if (addusercontroller!.selecteddepart == 'Select Department') {
      if (!(addusercontroller!.selectedpost.value == 'Super Admin' ||
          addusercontroller!.selectedpost.value == 'Admin')) {
        showsnackbar(titel: 'Alert !!!', detail: 'Please select department...');
        return false;
      }
    }
    if (addusercontroller!.selectedpost == 'Select Post') {
      showsnackbar(titel: 'Alert !!!', detail: 'Please select post...');
      return false;
    }

    return true;
  }

  saveeditdata({
    required AddEditUserController controll,
  }) async {
    controll.changebtnstate(1);

    try {
      dynamic data = await makehttppost(
        path: 'Users/adduser.php',
        functionname: "saveeditUserdata",
        data: newUserModelToJson(makedatabody()),
      );

      if (data == null) return;
      data = jsonDecode(data);
      if (data['Status'] == true) {
        controll.changebtnstate(2);
        showsnackbar(titel: 'Success', detail: data['Msj']);
        controll.onnewuser();
        controll.userdata = NewUserModel();
        Get.find<MangerListCtrl>().getrecords();
        Get.find<TelecallerListCtrl>().getrecords();
        Get.find<AdminPageWebCtrl>().getrecords();
      } else {
        controll.changebtnstate(3);
        showsnackbar(titel: 'Failed', detail: data['Msj']);
      }
    } catch (e) {
      controll.changebtnstate(3);
      debugPrint("Server: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Padding(
                padding: const EdgeInsets.only(top: 20, left: 25),
                child: (addusercontroller!.pagetitel.value)
                    .text
                    .xl3
                    .color(Get.theme.colorScheme.onSecondary)
                    .fontFamily('PoppinsSemiBold')
                    .make())),
            Column(
              children: [
                ResponsiveLayout(
                  computer: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildonerow(
                        widget1: buildcompanyid(controller: addusercontroller!),
                        widget2:
                            buildcompanyname(controller: addusercontroller!),
                      ),
                      // buildonerow(
                      //   widget1: builduserid(controller: addusercontroller!),
                      //   widget2:
                      //       builduserpassword(controller: addusercontroller!),
                      // ),
                      buildonerow(
                        widget1: buildusername(controller: addusercontroller!),
                        widget2:
                            builduserpassword(controller: addusercontroller!),
                      ),
                      buildonerow(
                        widget1: buildmobile(controller: addusercontroller!),
                        widget2: buildaltmobile(controller: addusercontroller!),
                      ),
                      buildonerow(
                        widget1: buildemail(controller: addusercontroller!),
                        widget2: buildcountry(controller: addusercontroller!),
                      ),
                      buildonerow(
                        widget1: buildstate(controller: addusercontroller!),
                        widget2: buildcity(controller: addusercontroller!),
                      ),
                      buildonerow(
                        widget1: buildbankname(controller: addusercontroller!),
                        widget2: buildaccount(controller: addusercontroller!),
                      ),
                      buildonerow(
                        widget1: buildifsc(controller: addusercontroller!),
                        widget2: builddatacode(controller: addusercontroller!),
                      ),
                      buildonerow(
                        widget1: builduserstatusdrop(
                            controller: addusercontroller!, context: context),
                        widget2: buildgenderdrop(
                            controller: addusercontroller!, context: context),
                      ),
                      // buildonerow(
                      //     widget1:
                      //         builduserpassword(controller: addusercontroller!),
                      //     widget2: builddatacode(controller: addusercontroller!)),
                      buildonerow(
                        widget1: buildpostdrop(
                            controller: addusercontroller!, context: context),
                        widget2: Obx(() => Visibility(
                              visible:
                                  !(addusercontroller!.selectedpost.value ==
                                          'Super Admin' ||
                                      addusercontroller!.selectedpost.value ==
                                          'Admin'),
                              child: builddepartdrop(
                                context: context,
                                controller: addusercontroller!,
                              ),
                            )),
                      ),
                      Obx(
                        () => Visibility(
                          visible: (addusercontroller!.selectedpost.value ==
                                  'Manager' ||
                              addusercontroller!.selectedpost.value ==
                                  'Telecaller'),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 20),
                                      child: "Please Assign Permission To User."
                                          .text
                                          .color(
                                              Get.theme.colorScheme.secondary)
                                          .align(TextAlign.left)
                                          .fontFamily('PoppinsSemiBold')
                                          .xl2
                                          .make(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                buildpermissonwrap(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      buildbutton(
                          context: context, controll: addusercontroller!),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  phone: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildcompanyid(controller: addusercontroller!),
                        buildcompanyname(controller: addusercontroller!),

                        builduserpassword(controller: addusercontroller!),
                        buildusername(controller: addusercontroller!),
                        // buildfathername(controller: addusercontroller!),
                        buildmobile(controller: addusercontroller!),
                        buildaltmobile(controller: addusercontroller!),
                        buildemail(controller: addusercontroller!),
                        buildcountry(controller: addusercontroller!),
                        buildstate(controller: addusercontroller!),
                        buildcity(controller: addusercontroller!),
                        // buildpincode(controller: addusercontroller!),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildbutton({
    required AddEditUserController controll,
    required context,
  }) {
    return Obx(() => buildanimatebtntext(
          ontap: () async {
            if (controll.buttonstate == ButtonState.idle) {
              if (validateform()) {
                var result = await makeconfirmation(
                    context: context,
                    titel: 'Confirmation',
                    content: 'Do you want to save this ?',
                    yestobutton: true);

                if (result == true) {
                  saveeditdata(controll: controll);
                }
              }

              // controll.changebtnstate(1);
            }
          },
          key: 'AddeditUser',
          success: "Success",
          idel: "Save",
          fail: "Failed",
          loading: "Saving...",
          state: controll.buttonstate.value,
        ));
  }

  Wrap buildpermissonwrap() {
    return Wrap(
      runSpacing: 5,
      alignment: WrapAlignment.start,
      children: [
        buildaddEditDepartments(controller: addusercontroller!),
        buildaddEditResponse(controller: addusercontroller!),
        buildaddEditUser(controller: addusercontroller!),
        buildaddEditLead(controller: addusercontroller!),
        builddeleteUpdateLead(controller: addusercontroller!),
        buildviewReports(controller: addusercontroller!),
        builddownloadReport(controller: addusercontroller!),
        buildupdateReport(controller: addusercontroller!),
        buildmakeCall(controller: addusercontroller!),
        buildsendSms(controller: addusercontroller!),
        buildsendMail(controller: addusercontroller!),
      ],
    );
  }

  Widget buildonerow({
    required Widget widget1,
    required Widget widget2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: widget1,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 3,
          child: widget2,
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  Widget buildcompanyid({
    required AddEditUserController controller,
  }) {
    return Visibility(
      visible: Get.find<LogeduserControll>().showcompoption.value,
      child: MyTextField(
        hint: "Enter Company Id",
        lable: "Company Id",
        onchange: (value) {
          EasyDebounce.debounce('Compid', const Duration(milliseconds: 800),
              () {
            getcompnamebyid(compid: value).then((value) {
              controller.companynamectrl.text = value;
            });
          });
        },
        keyboardtype: TextInputType.name,
        controller: addusercontroller!.companyidctrl,
      ),
    );
  }

  Widget buildcompanyname({
    required AddEditUserController controller,
  }) {
    return Visibility(
      visible: Get.find<LogeduserControll>().showcompoption.value,
      child: MyTextField(
        hint: "Enter Company Name",
        enable: false,
        lable: "Company Name*",
        keyboardtype: TextInputType.name,
        controller: addusercontroller!.companynamectrl,
      ),
    );
  }

  Widget builduserpassword({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Password",
      lable: "Password*",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.passwrodctrl,
    );
  }

  Widget buildusername({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Full Name",
      lable: "Full Name*",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.usernamectrl,
    );
  }

  Widget buildmobile({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Mobile Number",
      lable: "Mobile*",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.mobilectrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowmobile),
      ],
      maxlength: 15,
    );
  }

  Widget buildaltmobile({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Alt. Mobile Number",
      lable: "Alt. Mobile",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.altmobilectrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowmobile),
      ],
      maxlength: 15,
    );
  }

  Widget buildemail({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Email Id",
      lable: "Email Id",
      keyboardtype: TextInputType.emailAddress,
      controller: addusercontroller!.emailctrl,
      maxlength: 40,
    );
  }

  Widget buildcountry({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Country Name",
      lable: "Country*",
      keyboardtype: TextInputType.name,
      sufix: IconButton(
        onPressed: () {
          showCSCPikcer(
              onCountychange: (value) {
                addusercontroller!.counttyctrl.text = value;
              },
              onStatechange: (value) {
                addusercontroller!.statectrl.text = value;
              },
              onCitychange: (value) {
                addusercontroller!.cityctrl.text = value;
              },
              context: context);
        },
        icon: Icon(Icons.place, color: Get.theme.colorScheme.secondary),
      ),
      controller: addusercontroller!.counttyctrl,
    );
  }

  Widget buildstate({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter State Name",
      lable: "State*",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.statectrl,
    );
  }

  Widget buildcity({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter City Name",
      lable: "City*",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.cityctrl,
    );
  }

  Widget buildbankname({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Bank Name",
      lable: "Bank Name",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.banknamectrl,
    );
  }

  Widget buildaccount({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Account Number",
      lable: "Account Number",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.accountctrl,
    );
  }

  Widget buildifsc({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter IFSC Code",
      lable: "IFSC Code",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.ifsctrl,
    );
  }

  Widget builddatacode({
    required AddEditUserController controller,
  }) {
    return MyTextField(
      hint: "Enter Data Code",
      lable: "Data Code",
      keyboardtype: TextInputType.name,
      controller: addusercontroller!.datacodectrl,
    );
  }

  Widget builduserstatusdrop({
    required context,
    required AddEditUserController controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
      ),
      child: buidldropdown(
        onchange: (value) {
          controller.selectedstatus.value = value;
        },
        itemslist: userstatuslist,
        initvalue: controller.selectedstatus.value,
        hinttext: 'Please select status',
        context: context,
      ),
    );
  }

  Widget buildgenderdrop({
    required context,
    required AddEditUserController controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
      ),
      child: buidldropdown(
        onchange: (value) {
          controller.selectedgender.value = value;
        },
        itemslist: genderlist,
        initvalue: controller.selectedgender.value,
        hinttext: genderlist[0],
        context: context,
      ),
    );
  }

  Widget buildpostdrop({
    required context,
    required AddEditUserController controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
      ),
      child: buidldropdown(
        onchange: (value) {
          controller.updatepost(value);
        },
        itemslist: logeduserctrl!.allowedpost,
        initvalue: controller.selectedpost.value,
        hinttext: "Select Post",
        context: context,
      ),
    );
  }

  Widget builddepartdrop({
    required context,
    required AddEditUserController controller,
  }) {
    List<String> _departs = [
      ...List.generate(logeduserctrl!.comDepartmentList.length, (index) {
        return logeduserctrl!.comDepartmentList[index].department.toString();
      }),
    ];
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
      ),
      child: buidldropdown(
        onchange: (value) {
          controller.selecteddepart.value = value;
        },
        itemslist: [
          'Select Department',
          ..._departs,
        ],
        initvalue: _departs.contains(controller.selecteddepart.value)
            ? controller.selecteddepart.value
            : null,
        hinttext: 'Select Department',
        context: context,
      ),
    );
  }

  Widget buildonepermission({
    ValueChanged? onchange,
    required bool value,
    required String lable,
  }) {
    return Container(
      height: 50,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: Text(lable).text.bold.color(kdblackcolor).make(),
        ),
        Switch(
          value: value,
          activeColor: kdgreencolor,
          inactiveTrackColor: Constants.kdred,
          onChanged: (value) => onchange!(value),
        ),
      ]),
    );
  }

  Widget buildaddEditDepartments({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: (controller.isselectmanager()),
        child: buildonepermission(
          lable: "Can User Add/Edit Departments ?",
          value: controller.addEditDepartmetn.value,
          onchange: (value) {
            controller.addEditDepartmetn.value = value;
          },
        ),
      );
    });
  }

  Widget buildaddEditResponse({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: (controller.isselectmanager()),
        child: buildonepermission(
          lable: "Can User Add/Edit Response ?",
          value: controller.addEditResponse.value,
          onchange: (value) {
            controller.addEditResponse.value = value;
          },
        ),
      );
    });
  }

  Widget buildaddEditUser({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: (controller.isselectmanager()),
        child: buildonepermission(
          lable: "Can User Add/Edit User ?",
          value: controller.addEditUser.value,
          onchange: (value) {
            controller.addEditUser.value = value;
          },
        ),
      );
    });
  }

  Widget buildaddEditLead({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: (controller.isselectmanager()),
        child: buildonepermission(
          lable: "Can User Add/Edit Leads ?",
          value: controller.addEditLead.value,
          onchange: (value) {
            controller.addEditLead.value = value;
          },
        ),
      );
    });
  }

  Widget builddeleteUpdateLead({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: false,
        child: buildonepermission(
          lable: "Can User Delete Leads ?",
          value: controller.deleteUpdateLead.value,
          onchange: (value) {
            controller.deleteUpdateLead.value = value;
          },
        ),
      );
    });
  }

  Widget buildviewReports({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: (controller.isselectmanager()),
        child: buildonepermission(
          lable: "Can User View Reports ?",
          value: controller.viewReports.value,
          onchange: (value) {
            controller.viewReports.value = value;
          },
        ),
      );
    });
  }

  Widget builddownloadReport({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: false,
        child: buildonepermission(
          lable: "Can User Download Reports ?",
          value: controller.downloadReport.value,
          onchange: (value) {
            controller.downloadReport.value = value;
          },
        ),
      );
    });
  }

  Widget buildupdateReport({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: (controller.isselectmanager()),
        child: buildonepermission(
          lable: "Can User Update Reports ?",
          value: controller.updateReport.value,
          onchange: (value) {
            controller.updateReport.value = value;
          },
        ),
      );
    });
  }

  Widget buildmakeCall({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        visible:
            (controller.isselectmanager() || controller.isselecttelecaller()),
        child: buildonepermission(
          lable: "Can User Make Calls ?",
          value: controller.makeCall.value,
          onchange: (value) {
            controller.makeCall.value = value;
          },
        ),
      );
    });
  }

  Widget buildsendSms({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        // visible:
        //     (controller.isselectmanager() || controller.isselecttelecaller()),
        visible: false,
        child: buildonepermission(
          lable: "Can User Send Sms ?",
          value: controller.sendSms.value,
          onchange: (value) {
            controller.sendSms.value = value;
          },
        ),
      );
    });
  }

  Widget buildsendMail({
    required AddEditUserController controller,
  }) {
    return Obx(() {
      return Visibility(
        // visible:
        //     (controller.isselectmanager() || controller.isselecttelecaller()),
        visible: false,
        child: buildonepermission(
          lable: "Can User Send Email ?",
          value: controller.sendMail.value,
          onchange: (value) {
            controller.sendMail.value = value;
          },
        ),
      );
    });
  }

  NewUserModel makedatabody() {
    addusercontroller!.userdata.logedUserId =
        Get.find<LogeduserControll>().logeduserdetail.value.logeduserId;
    addusercontroller!.userdata.logedUserName =
        Get.find<LogeduserControll>().logeduserdetail.value.logeduserName;
    addusercontroller!.userdata.isnewuser =
        addusercontroller!.isnewform.value ? '1' : '0';
    addusercontroller!.userdata.companyId =
        Get.find<LogeduserControll>().logeduserdetail.value.compId;

    addusercontroller!.userdata.companyName =
        Get.find<LogeduserControll>().logeduserdetail.value.compName;
    if (Get.find<LogeduserControll>().showcompoption.value) {
      addusercontroller!.userdata.companyId =
          addusercontroller!.companyidctrl.text;
      addusercontroller!.userdata.companyName =
          addusercontroller!.companynamectrl.text;
    }
    // userdata.userId = addusercontroller!.usridctrl.text;
    addusercontroller!.userdata.fullName = addusercontroller!.usernamectrl.text;

    addusercontroller!.userdata.mobile = addusercontroller!.mobilectrl.text;
    addusercontroller!.userdata.userstatus =
        addusercontroller!.selectedstatus.value;
    addusercontroller!.userdata.altMobile =
        addusercontroller!.altmobilectrl.text;
    addusercontroller!.userdata.email = addusercontroller!.emailctrl.text;
    addusercontroller!.userdata.country = addusercontroller!.counttyctrl.text;
    addusercontroller!.userdata.state = addusercontroller!.statectrl.text;
    addusercontroller!.userdata.city = addusercontroller!.cityctrl.text;
    addusercontroller!.userdata.bankName = addusercontroller!.banknamectrl.text;
    addusercontroller!.userdata.accountNumber =
        addusercontroller!.accountctrl.text;
    addusercontroller!.userdata.ifsc = addusercontroller!.ifsctrl.text;
    addusercontroller!.userdata.password = addusercontroller!.passwrodctrl.text;
    addusercontroller!.userdata.datacode = addusercontroller!.datacodectrl.text;
    addusercontroller!.userdata.gender =
        addusercontroller!.selectedgender.value;
    addusercontroller!.userdata.department =
        addusercontroller!.selecteddepart.value;
    addusercontroller!.userdata.designation =
        addusercontroller!.selectedpost.value;
    addusercontroller!.userdata.addEditDepartmetn =
        addusercontroller!.addEditDepartmetn.value ? '1' : '0';
    addusercontroller!.userdata.addEditResponse =
        addusercontroller!.addEditResponse.value ? '1' : '0';
    addusercontroller!.userdata.addEditUser =
        addusercontroller!.addEditUser.value ? '1' : '0';
    addusercontroller!.userdata.addEditLead =
        addusercontroller!.addEditLead.value ? '1' : '0';
    addusercontroller!.userdata.deleteUpdateLead =
        addusercontroller!.deleteUpdateLead.value ? '1' : '0';
    addusercontroller!.userdata.viewReports =
        addusercontroller!.viewReports.value ? '1' : '0';
    addusercontroller!.userdata.downloadReport =
        addusercontroller!.downloadReport.value ? '1' : '0';
    addusercontroller!.userdata.updateReport =
        addusercontroller!.updateReport.value ? '1' : '0';
    addusercontroller!.userdata.makeCall =
        addusercontroller!.makeCall.value ? '1' : '0';
    addusercontroller!.userdata.sendSms =
        addusercontroller!.sendSms.value ? '1' : '0';
    addusercontroller!.userdata.sendMail =
        addusercontroller!.sendMail.value ? '1' : '0';

    return addusercontroller!.userdata;
  }
}
