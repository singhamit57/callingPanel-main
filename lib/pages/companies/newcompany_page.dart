// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/constants/validate_exp.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/functions/date_format.dart';
import 'package:callingpanel/functions/dio_request.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/mini_widgets.dart/animated_button.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:callingpanel/widgets/reuseable/csc_pickerwidget.dart';
import 'package:callingpanel/widgets/reuseable/datepic_texshow.dart';
import 'package:callingpanel/widgets/reuseable/mytext_field.dart';
import 'package:callingpanel/widgets/reuseable/str_dropdown.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:velocity_x/velocity_x.dart';

import 'company_controller.dart';

DateTime nowdate = DateTime.now();

class AddEditCompanyPage extends StatefulWidget {
  const AddEditCompanyPage({Key? key}) : super(key: key);

  @override
  _AddRemoveUsersPageState createState() => _AddRemoveUsersPageState();
}

CompanyPageCtrl? addeditcompany;
LogeduserControll? logeduserctrl;
List<String> companystatuslist = ['Company Status', 'Active', 'Block'];

class _AddRemoveUsersPageState extends State<AddEditCompanyPage> {
  @override
  void initState() {
    addeditcompany = Get.find<CompanyPageCtrl>();
    logeduserctrl = Get.find<LogeduserControll>();
    // onnewuser();
    super.initState();
  }

  @override
  void dispose() {
    addeditcompany!.onPageOpen();
    super.dispose();
  }

  bool validateform() {
    if (addeditcompany!.companynamectrl.text.length < 3) {
      showsnackbar(
          titel: 'Alert !!!', detail: 'Please enter full company name...');
      return false;
    }

    if (addeditcompany!.emailctrl.text.length < 4) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter email id...');
      return false;
    } else if (!addeditcompany!.emailctrl.text.isEmail) {
      showsnackbar(
          titel: 'Alert !!!', detail: 'Please enter valid email id...');
      return false;
    }

    if (addeditcompany!.mobilectrl.text.length < 4) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter mobile number...');
      return false;
    }
    if (addeditcompany!.counttyctrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter country name...');
      return false;
    }
    if (addeditcompany!.statectrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter state name...');
      return false;
    }
    if (addeditcompany!.cityctrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter city name...');
      return false;
    }
    if (addeditcompany!.emailctrl.text.length < 3) {
      showsnackbar(
          titel: 'Alert !!!', detail: 'Please enter responses limit...');
      return false;
    }

    if (addeditcompany!.selecteddateshow.value == 'Activation Date') {
      showsnackbar(
          titel: 'Alert !!!', detail: 'Please select activation date...');
      return false;
    }
    if (addeditcompany!.selectedstatus == 'Company Status') {
      showsnackbar(
          titel: 'Alert !!!', detail: "Please select company's status...");
      return false;
    }

    if (addeditcompany!.compprefixctrl.text.length < 4) {
      showsnackbar(
          titel: 'Alert !!!', detail: "Please make company's prefix...");
      return false;
    }

    return true;
  }

  saveeditdata({
    required CompanyPageCtrl controll,
  }) async {
    controll.changebtnstate(1);
    var body = {
      "LogedUserID":
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      "LogedUserName":
          Get.find<LogeduserControll>().logeduserdetail.value.logeduserName,
      "LogedUserCompID":
          Get.find<LogeduserControll>().logeduserdetail.value.compId,
      ...controll.newcompanyDetails.toJson(),
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

//controll.newcompanyDetails
    try {
      dynamic data = await makehttppost(
        path: '/company/addeditcompany.php',
        functionname: "saveeditdata",
        data: jsonEncode(body),
      );

      if (data == null) return;
      data = jsonDecode(data);
      if (data['Status'] == true) {
        controll.changebtnstate(2);
        controll.onPageOpen();
        showsnackbar(titel: 'Success', detail: data['Msj']);
        controll.getCompanieslist();
        Get.find<WorkPageController>().setworkpage(PageSwitch.companies);
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
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 20, left: 25),
              child: (addeditcompany!.pagetitelshow.value)
                  .text
                  .xl3
                  .color(kdyellowcolor)
                  .make()),
          Column(
            children: [
              ResponsiveLayout(
                computer: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildonerow(
                      widget1: buildcompanyname(controller: addeditcompany!),
                      widget2: buildemail(controller: addeditcompany!),
                    ),
                    buildonerow(
                      widget1: buildmobile(controller: addeditcompany!),
                      widget2: buildaltmobile(controller: addeditcompany!),
                    ),
                    buildonerow(
                      widget1: buildcountry(controller: addeditcompany!),
                      widget2: buildstate(controller: addeditcompany!),
                    ),
                    buildonerow(
                      widget1: buildcity(controller: addeditcompany!),
                      widget2: builMaxResponses(controller: addeditcompany!),
                    ),
                    buildonerow(
                      widget1: builMaxDepart(controller: addeditcompany!),
                      widget2: builMaxManagers(controller: addeditcompany!),
                    ),
                    buildonerow(
                      widget1: builMaxTelecallers(controller: addeditcompany!),
                      widget2: buildcompprefix(controller: addeditcompany!),
                    ),
                    buildonerow(
                      widget1: buildactivedate(),
                      widget2: builduserstatusdrop(
                          controller: addeditcompany!, context: context),
                    ),
                    buildonerow(
                      widget1: buildsendSms(controller: addeditcompany!),
                      widget2: buildsendMail(controller: addeditcompany!),
                    ),
                    Center(
                      child: buildbutton(
                          context: context, controll: addeditcompany!),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildbutton({
    required CompanyPageCtrl controll,
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

  Widget buildonerow({
    Widget? widget1,
    Widget? widget2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: widget1 ?? const SizedBox(),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 3,
          child: widget2 ?? const SizedBox(),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  Widget buildcompanyname({
    required CompanyPageCtrl controller,
  }) {
    return Visibility(
      visible: true,
      child: MyTextField(
        hint: "Enter Company Name",
        lable: "Company Name*",
        onchange: (value) {
          addeditcompany!.newcompanyDetails.compName = value;
        },
        keyboardtype: TextInputType.name,
        controller: addeditcompany!.companynamectrl,
      ),
    );
  }

  Widget buildcompprefix({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Make Company's Prefix",
      lable: "Prefix*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.compPrefix = value;
      },
      keyboardtype: TextInputType.name,
      controller: addeditcompany!.compprefixctrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowcharacOnly),
      ],
      maxlength: 6,
    );
  }

  Widget buildmobile({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter Mobile Number",
      lable: "Mobile*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.compMobile = value;
      },
      keyboardtype: TextInputType.name,
      controller: addeditcompany!.mobilectrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowmobile),
      ],
      maxlength: 15,
    );
  }

  Widget buildaltmobile({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter Alt. Mobile Number",
      lable: "Alt. Mobile",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.compAltMobile = value;
      },
      keyboardtype: TextInputType.name,
      controller: addeditcompany!.altmobilectrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowmobile),
      ],
      maxlength: 15,
    );
  }

  Widget buildemail({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter Email Id",
      lable: "Email Id*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.compEmail = value;
      },
      keyboardtype: TextInputType.emailAddress,
      controller: addeditcompany!.emailctrl,
    );
  }

  Widget buildcountry({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter Country Name",
      lable: "Country*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.country = value;
      },
      keyboardtype: TextInputType.name,
      controller: addeditcompany!.counttyctrl,
      sufix: InkWell(
          onTap: () {
            showCSCPikcer(
                onCountychange: (value) {
                  addeditcompany!.counttyctrl.text = value;
                },
                onStatechange: (value) {
                  addeditcompany!.statectrl.text = value;
                },
                onCitychange: (value) {
                  addeditcompany!.cityctrl.text = value;
                },
                context: context);
          },
          child: Icon(
            Icons.place,
            color: Get.theme.colorScheme.primary,
          )),
    );
  }

  Widget buildstate({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter State Name",
      lable: "State*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.state = value;
      },
      keyboardtype: TextInputType.name,
      controller: addeditcompany!.statectrl,
    );
  }

  Widget buildcity({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter City Name",
      lable: "City*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.city = value;
      },
      keyboardtype: TextInputType.name,
      controller: addeditcompany!.cityctrl,
    );
  }

  Widget builMaxResponses({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter Maximum Responses Limit",
      lable: "Responses*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.maxResponses = value;
      },
      keyboardtype: TextInputType.number,
      controller: addeditcompany!.maxresponsectrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowint),
      ],
      maxlength: 10,
    );
  }

  Widget builMaxDepart({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter Maximum Department Limit",
      lable: "Department*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.maxDeparts = value;
      },
      keyboardtype: TextInputType.number,
      controller: addeditcompany!.maxdepartctrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowint),
      ],
      maxlength: 10,
    );
  }

  Widget builMaxManagers({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter Maximum Managers Limit",
      lable: "Managers*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.maxManagers = value;
      },
      keyboardtype: TextInputType.number,
      controller: addeditcompany!.maxmanagerctrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowint),
      ],
      maxlength: 10,
    );
  }

  Widget builMaxTelecallers({
    required CompanyPageCtrl controller,
  }) {
    return MyTextField(
      hint: "Enter Maximum Telecaller Limit",
      lable: "Telecaller*",
      onchange: (value) {
        addeditcompany!.newcompanyDetails.maxTelecallers = value;
      },
      keyboardtype: TextInputType.number,
      controller: addeditcompany!.maxtelecallerctrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowint),
      ],
      maxlength: 10,
    );
  }

  Widget buildactivedate() {
    return Obx(() => Container(
          padding: const EdgeInsets.only(left: 20),
          child: datepickershowtext(
              context: context,
              value: addeditcompany!.selecteddateshow.value,
              ontap: () {
                showDatePicker(
                        context: context,
                        initialDate: nowdate,
                        confirmText: 'Done',
                        cancelText: 'Close',
                        builder: (context, Widget? child) {
                          return Theme(
                              data: ThemeData(
                                primaryColor: Get.theme.primaryColorDark,
                              ),
                              child: child!);
                        },
                        firstDate: DateTime(nowdate.year),
                        lastDate: DateTime(nowdate.year + 1))
                    .then((value) {
                  if (value != null) {
                    addeditcompany!.selecteddate.value = value;
                    addeditcompany!.newcompanyDetails.activateDate =
                        value.toString();
                    addeditcompany!.selecteddateshow.value = date_dMyy(value);
                  }
                });
              }),
        ));
  }

  Widget builduserstatusdrop({
    required context,
    required CompanyPageCtrl controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
      ),
      child: buidldropdown(
        onchange: (value) {
          controller.selectedstatus.value = value;
          controller.newcompanyDetails.compStatus = value;
        },
        itemslist: companystatuslist,
        initvalue: controller.selectedstatus.value,
        hinttext: 'Please select status',
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
      margin: const EdgeInsets.only(left: 20),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: Text(lable).text.bold.color(kdblackcolor).make(),
        ),
        Switch(
          value: value,
          activeColor: kdskyblue,
          inactiveTrackColor: Constants.kdred,
          onChanged: (value) => onchange!(value),
        ),
      ]),
    );
  }

  Widget buildsendSms({
    required CompanyPageCtrl controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: true,
        child: buildonepermission(
          lable: "Can Company Send Sms ?",
          value: controller.sendSms.value,
          onchange: (value) {
            controller.sendSms.value = value;
            controller.newcompanyDetails.smsEnable = value ? '1' : '0';
          },
        ),
      );
    });
  }

  Widget buildsendMail({
    required CompanyPageCtrl controller,
  }) {
    return Obx(() {
      return Visibility(
        visible: true,
        child: buildonepermission(
          lable: "Can Company Send Email ?",
          value: controller.sendMail.value,
          onchange: (value) {
            controller.sendMail.value = value;
            controller.newcompanyDetails.mailEnable = value ? '1' : '0';
          },
        ),
      );
    });
  }
}
