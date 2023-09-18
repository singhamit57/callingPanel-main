import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/functions/date_format.dart';
import 'package:callingpanel/functions/make_email.dart';
import 'package:callingpanel/functions/make_call.dart';
import 'package:callingpanel/mini_widgets.dart/animated_button.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/models/leads/leadfulldetail_model.dart';
import 'package:callingpanel/widgets/reuseable/csc_pickerwidget.dart';
import 'package:callingpanel/widgets/reuseable/datepic_texshow.dart';
import 'package:callingpanel/widgets/reuseable/mytext_field.dart';
import 'package:callingpanel/widgets/reuseable/scrollabletextfield.dart';
import 'package:callingpanel/widgets/reuseable/str_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'callresponse_controller.dart';
import 'package:http/http.dart' as http;

DateTime nowdate = DateTime.now();
final iconcolor = Get.theme.colorScheme.primary.withOpacity(.6);
final iconbtncolor = Get.theme.colorScheme.secondary;

class MobileCallResponsePage extends StatefulWidget {
  final String? herotag;
  final LeadFullDetail? leaddata;
  // final bool isleaddata;
  final bool havedata;
  final String? datatype;
  const MobileCallResponsePage(
      {Key? key,
      this.herotag,
      this.leaddata,
      this.datatype = '',
      this.havedata = false})
      : super(key: key);

  @override
  _MobileCallResponsePageState createState() => _MobileCallResponsePageState();
}

CallResponseCtrlM? callresponsectrl;
LogeduserControll? logeduserctrl;

class _MobileCallResponsePageState extends State<MobileCallResponsePage> {
  @override
  void initState() {
    callresponsectrl = Get.find<CallResponseCtrlM>();
    logeduserctrl = Get.find<LogeduserControll>();
    callresponsectrl!.getdepartlist(
        departindata: widget.leaddata!.departments!, havedata: widget.havedata);
    endlastcall();
    // SchedulerBinding.instance!.addPostFrameCallback((_) {
    //   callresponsectrl!.getdepartlist(
    //       departindata: widget.leaddata!.departments!,
    //       havedata: widget.havedata);
    // });

    initialsetup();
    super.initState();
  }

  String nanullcheck(value) {
    try {
      if (value == null || value == 'NA') {
        return '';
      } else {
        return value.toString();
      }
    } catch (e) {
      return '';
    }
  }

  bool fieldenable({String? name}) {
    if (widget.datatype == 'callhistory' || widget.datatype == 'leaddata') {
      if (name != null) {
        return false;
      }
    }
    return true;
  }

  initialsetup() {
    // callresponsectrl!.getdepartlist();
    callresponsectrl!.namectrl.text = nanullcheck(widget.leaddata!.fullName);
    callresponsectrl!.mobilectrl.text = nanullcheck(widget.leaddata!.mobile);
    callresponsectrl!.altmobilectrl.text =
        nanullcheck(widget.leaddata!.altMobile);
    callresponsectrl!.emailctrl.text = nanullcheck(widget.leaddata!.email);
    callresponsectrl!.profilectrl.text = nanullcheck(widget.leaddata!.profile);
    callresponsectrl!.countryctrl.text = nanullcheck(widget.leaddata!.country);
    callresponsectrl!.statectrl.text = nanullcheck(widget.leaddata!.state);
    callresponsectrl!.cityctrl.text = nanullcheck(widget.leaddata!.city);
    callresponsectrl!.remarkctrl.text =
        nanullcheck(widget.leaddata!.lastRemark);
    callresponsectrl!.meetingdateshow.value = 'Select Date';
    callresponsectrl!.selecteddepart.value =
        (widget.leaddata!.departments ?? 'Select Department');
    callresponsectrl!.selectedresponse.value = 'Select Response';
    callresponsectrl!.selecteddate.value = DateTime.now();
    callresponsectrl!.selectedpriority.value = 'Select Priority';
    callresponsectrl!.selectedresult.value = 'Select Result';
    callresponsectrl!.changebtnstate(0);
    if (widget.datatype == 'callhistory') {
      getleaddetails();
    }
  }

  getleaddetails() async {
    callresponsectrl!.issearching.value = true;
    String _url = mainurl + '/leaddatabase/oneleaddetail_app.php';
    var body = {
      'CompId': Get.find<LogeduserControll>().logeduserdetail.value.compId,
      'UserID': Get.find<LogeduserControll>().logeduserdetail.value.logeduserId,
      'LeadId': widget.leaddata!.tableId ?? '',
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          var resultdata = data['ResultData'];
          callresponsectrl!.namectrl.text = nanullcheck(resultdata['FullName']);
          callresponsectrl!.mobilectrl.text = nanullcheck(resultdata['Mobile']);
          callresponsectrl!.altmobilectrl.text =
              nanullcheck(resultdata['AltMobile']);
          callresponsectrl!.emailctrl.text = nanullcheck(resultdata['Email']);
          callresponsectrl!.profilectrl.text =
              nanullcheck(resultdata['Profile']);
          callresponsectrl!.countryctrl.text =
              nanullcheck(resultdata['Country']);
          callresponsectrl!.statectrl.text = nanullcheck(resultdata['State']);
          callresponsectrl!.cityctrl.text = nanullcheck(resultdata['City']);
          callresponsectrl!.selecteddepart.value =
              nanullcheck(resultdata['LastDepartment']);
          callresponsectrl!
              .getresponselist(callresponsectrl!.selecteddepart.value);
        }
      }
      callresponsectrl!.issearching.value = false;
    } catch (e) {
      callresponsectrl!.issearching.value = false;
    }
    callresponsectrl!.issearching.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Get.theme.primaryColorDark,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            // color: kdwhitecolor,
          ),
        ),
        // centerTitle: true,
        title: "Lead Details"
            .text
            .color(Get.theme.colorScheme.onSecondary)
            .fontFamily('PoppinsSemiBold')
            .xl2
            .make(),
        elevation: 0,
      ),
      // floatingActionButton: InkWell(
      //   child: CircleAvatar(
      //     radius: 25,
      //     backgroundColor: Constants.kdorange.withOpacity(.95),
      //     child: Icon(
      //       Icons.call,
      //       // color: Get.theme.primaryColorDark,
      //       color: kdwhitecolor,
      //     ),
      //   ),
      // ),
      body: Hero(
        tag: widget.herotag ?? '',
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => callresponsectrl!.issearching.value
                  ? buildLinerloading()
                  : const SizedBox()),
              const SizedBox(
                height: 5,
              ),
              MyTextField(
                hint: 'Enter FullName',
                lable: 'Name',
                controller: callresponsectrl!.namectrl,
                enable: fieldenable(name: 'fullname'),
                prifix: Icon(
                  Icons.person,
                  color: iconcolor,
                  size: 22,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                keyboardtype: TextInputType.name,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: MyTextField(
                      hint: 'Enter Mobile',
                      lable: 'Mobile',
                      enable: fieldenable(name: 'mobile'),
                      controller: callresponsectrl!.mobilectrl,
                      prifix: Icon(
                        Icons.phone,
                        color: iconcolor,
                        size: 22,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      keyboardtype: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: IconButton(
                      onPressed: () {
                        makemycall(
                            context: context,
                            frompagename: "MobileCallResponsePage",
                            leadid: '',
                            lable: callresponsectrl!.namectrl.text,
                            mobile: callresponsectrl!.mobilectrl.text);
                      },
                      icon: const Icon(Icons.call),
                      color: iconbtncolor,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: MyTextField(
                      hint: 'Enter Alt Mobile',
                      lable: 'Alt. Mobile',
                      enable: fieldenable(name: 'altmobile'),
                      controller: callresponsectrl!.altmobilectrl,
                      prifix: Icon(
                        Icons.phone_android,
                        color: iconcolor,
                        size: 22,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      keyboardtype: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: IconButton(
                      onPressed: () {
                        makemycall(
                            context: context,
                            frompagename: "MobileCallResponsePage",
                            leadid: '',
                            lable: callresponsectrl!.namectrl.text,
                            mobile: callresponsectrl!.altmobilectrl.text);
                      },
                      icon: const Icon(Icons.call),
                      color: iconbtncolor,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: MyTextField(
                      hint: 'Enter Email Id',
                      lable: 'Email',
                      enable: fieldenable(name: 'email'),
                      controller: callresponsectrl!.emailctrl,
                      prifix: Icon(
                        Icons.send,
                        color: iconcolor,
                        size: 22,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      keyboardtype: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: IconButton(
                      onPressed: () {
                        sendMail(email: callresponsectrl!.emailctrl.text);
                      },
                      icon: const Icon(Icons.mail),
                      color: iconbtncolor,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
              MyTextField(
                hint: 'Enter Profile',
                lable: 'Profile',
                enable: fieldenable(name: 'profile'),
                controller: callresponsectrl!.profilectrl,
                prifix: Icon(
                  Icons.engineering,
                  color: iconcolor,
                  size: 22,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                keyboardtype: TextInputType.name,
              ),
              Stack(
                children: [
                  MyTextField(
                    hint: 'Enter Country',
                    lable: 'Country',
                    enable: fieldenable(name: 'country'),
                    controller: callresponsectrl!.countryctrl,
                    prifix: Icon(
                      Icons.flag,
                      color: iconcolor,
                      size: 22,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    keyboardtype: TextInputType.name,
                  ),
                  Visibility(
                    visible: fieldenable(name: 'country'),
                    child: Positioned(
                      right: 5,
                      bottom: 20,
                      child: InkWell(
                        onTap: () {
                          showCSCPikcer(
                            context: context,
                            onCountychange: (value) {
                              callresponsectrl!.countryctrl.text = value;
                            },
                            onStatechange: (value) {
                              callresponsectrl!.statectrl.text = value;
                            },
                            onCitychange: (value) {
                              callresponsectrl!.cityctrl.text = value;
                            },
                          );
                        },
                        child: Icon(
                          Icons.room,
                          color: Get.theme.colorScheme.secondary,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              MyTextField(
                hint: 'Enter State',
                lable: 'State',
                enable: fieldenable(name: 'state'),
                controller: callresponsectrl!.statectrl,
                prifix: Icon(
                  Icons.map,
                  color: iconcolor,
                  size: 22,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                keyboardtype: TextInputType.name,
              ),
              MyTextField(
                hint: 'Enter City',
                lable: 'City',
                enable: fieldenable(name: 'city'),
                controller: callresponsectrl!.cityctrl,
                prifix: Icon(
                  Icons.location_city,
                  color: iconcolor,
                  size: 22,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                keyboardtype: TextInputType.name,
              ),
              Obx(() {
                String initdepart = 'Select Department';
                if (callresponsectrl!.departoptions
                    .contains(callresponsectrl!.selecteddepart.value)) {
                  initdepart = callresponsectrl!.selecteddepart.value;
                }
                return Visibility(
                  visible: widget.datatype != 'newdata',
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      "Response"
                          .text
                          .color(Get.theme.colorScheme.primary)
                          .fontFamily('PoppinsSemiBold')
                          .size(22)
                          .makeCentered(),
                      const SizedBox(
                        height: 10,
                      ),
                      buildpostdrop(
                          context: context,
                          hint: 'Select Department',
                          value: initdepart,
                          onchange: (value) {
                            callresponsectrl!.selecteddepart.value = value;
                            callresponsectrl!.needdate.value = false;
                            callresponsectrl!.selectedresponse.value =
                                "Select Response";
                            callresponsectrl!.getresponselist(value);
                          },
                          list: callresponsectrl!.departoptions),
                      Visibility(
                        visible: callresponsectrl!.selecteddepart.value !=
                            'Select Department',
                        child: buildpostdrop(
                            context: context,
                            hint: 'Select Response',
                            onchange: (value) {
                              callresponsectrl!.needdate.value = false;
                              callresponsectrl!.selectedresponse.value = value;
                              callresponsectrl!.needmeetdate(value);
                            },
                            value: callresponsectrl!.selectedresponse.value,
                            list: callresponsectrl!.responseoptions),
                      ),
                      Visibility(
                        visible: callresponsectrl!.needdate.value,
                        child: datepickershowtext(
                            context: context,
                            ontap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: nowdate,
                                  firstDate: DateTime(
                                      nowdate.year, nowdate.month, nowdate.day),
                                  lastDate: DateTime(nowdate.year + 1),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                        data: Theme.of(context).copyWith(
                                          brightness: Brightness.light,
                                          dialogBackgroundColor:
                                              Get.theme.colorScheme.surface,
                                        ),
                                        child: child!);
                                  }).then((value) {
                                if (value != null) {
                                  callresponsectrl!.selecteddate.value = value;
                                  callresponsectrl!.meetingdateshow.value =
                                      date_dMyy(value);
                                }
                              });
                            },
                            value: callresponsectrl!.meetingdateshow.value),
                      ),
                      Visibility(
                        visible: callresponsectrl!.needdate.value,
                        child: builleadpriority(
                            context: context,
                            onchange: (value) {
                              callresponsectrl!.selectedpriority.value = value;
                            },
                            initvalue: 'Select Priority',
                            itemslist: [
                              'Select Priority',
                              'Hot Lead',
                              'Medium Lead',
                              'Cold Lead'
                            ],
                            hinttext: 'Select Priority'),
                      ),
                      myscrollabletextfield(
                          lable: 'Remark',
                          hint: "Write some remark",
                          // enable: fieldenable(name: 'remark'),
                          controller: callresponsectrl!.remarkctrl,
                          minheight: 120,
                          maxline: 6,
                          maxheight: 250),
                      const SizedBox(
                        height: 5,
                      ),
                      if (widget.havedata)
                        builleadpriority(
                            context: context,
                            onchange: (value) {
                              callresponsectrl!.selectedresult.value = value;
                              // FocusScope.of(context).unfocus();
                            },
                            initvalue: 'Select Result',
                            itemslist: [
                              'Select Result',
                              'Successfull',
                              'Pending',
                              'Cancelled'
                            ],
                            hinttext: 'Select Result'),
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              buildbutton(context: context, controll: callresponsectrl!),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildbutton({
    required CallResponseCtrlM controll,
    required context,
  }) {
    return Obx(() => buildanimatebtntext(
          ontap: () async {
            FocusScope.of(context).unfocus();
            // ignore: unrelated_type_equality_checks
            if (controll.buttonstate == ButtonState.idle) {
              var result = await makeconfirmation(
                  context: context,
                  titel: "Confirmation !!!",
                  content: 'Do you want to save this response ?',
                  yestobutton: true);
              if (result == false) {
                return;
              }

              controll.savevalidation(
                  context: context,
                  tableid: widget.leaddata!.tableId ?? '0',
                  datatype: widget.datatype ?? '',
                  havedata: widget.havedata);
            }
          },
          key: 'SaveLead',
          success: "Success",
          idel: "Save",
          fail: "Failed",
          loading: "Processing",
          state: controll.buttonstate.value,
        ));
  }

  Widget buildpostdrop({
    required context,
    required List<String> list,
    required String value,
    required String hint,
    required ValueChanged onchange,

    // required  controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 5,
      ),
      child: buidldropdown(
        onchange: onchange,
        itemslist: list,
        initvalue: value,
        hinttext: hint,
        context: context,
      ),
    );
  }
}

Widget builleadpriority(
    {required List<String> itemslist,
    required initvalue,
    required context,
    required String hinttext,
    required ValueChanged<String> onchange}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    decoration: BoxDecoration(
        border: Border.all(
            width: 1.0, color: Get.theme.colorScheme.primary.withOpacity(.4)),
        borderRadius: BorderRadius.circular(5.0)),
    child: Theme(
      data: Theme.of(context).copyWith(
          cardColor: Get.theme.scaffoldBackgroundColor,
          canvasColor: Get.theme.scaffoldBackgroundColor,
          focusColor: Get.theme.scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: Get.theme.primaryColor)),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: initvalue,
        dropdownColor: Get.theme.scaffoldBackgroundColor,
        focusColor: Get.theme.scaffoldBackgroundColor,
        iconEnabledColor: Get.theme.primaryColor,
        style: const TextStyle(
          color: kdyellowcolor,
        ),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          fillColor: Get.theme.scaffoldBackgroundColor,
          focusColor: Get.theme.scaffoldBackgroundColor,
        ),
        items: itemslist.map((value) {
          Color _stripcolor = Get.theme.colorScheme.primary;
          if (value == 'Hot Lead') {
            _stripcolor = kdgreencolor;
          }
          if (value == 'Medium Lead') {
            _stripcolor = kdyellowcolor;
          }
          if (value == 'Cold Lead') {
            _stripcolor = Constants.kdred;
          }
          if (value == 'Successfull') {
            _stripcolor = kdgreencolor;
          }
          if (value == 'Pending') {
            _stripcolor = kdyellowcolor;
          }
          if (value == 'Cancelled') {
            _stripcolor = Constants.kdred;
          }
          return DropdownMenuItem<String>(
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(width: 8, color: _stripcolor)),
                color: Get.theme.scaffoldBackgroundColor,
              ),
              child: value.text
                  .color(Get.theme.colorScheme.onSecondary)
                  .fontFamily('PoppinsRegular')
                  .make(),
            ),
            value: value,
          );
        }).toList(),
        hint: Text(hinttext),
        onChanged: (value) => onchange(value!),
      ),
    ),
  );
}
