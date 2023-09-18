import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/date_format.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/models/mobileappmodel/callerdetails_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'callerdetail_controller.dart';

DateTime nowdate = DateTime.now();

LogeduserControll? logeduserctrl;
CallerDetailCtrlM? callerpagectrl;

class MobileCallerDetailPage extends StatefulWidget {
  const MobileCallerDetailPage({Key? key}) : super(key: key);

  @override
  _MobileCallerDetailPageState createState() => _MobileCallerDetailPageState();
}

class _MobileCallerDetailPageState extends State<MobileCallerDetailPage> {
  @override
  void initState() {
    logeduserctrl = Get.find<LogeduserControll>();
    callerpagectrl = Get.put(CallerDetailCtrlM());
    getworkdata();
    super.initState();
  }

  getworkdata() {
    callerpagectrl!.getworkdetails(
        userid: logeduserctrl!.logeduserdetail.value.logeduserId,
        compid: logeduserctrl!.logeduserdetail.value.compId);
  }

  setdaterange() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(nowdate.year - 1),
      lastDate: DateTime(nowdate.year + 1),
      initialDateRange: callerpagectrl!.selecteddaterange,
      saveText: "Find",
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: Get.theme.primaryColorDark,
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        callerpagectrl!.selecteddaterange = value;
        getworkdata();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgrounsColor,
        appBar: PreferredSize(
          child: AppBar(
            // centerTitle: true,
            title: "User Details".text.color(kdwhitecolor).bold.size(22).make(),
            actions: [
              IconButton(
                  onPressed: () {
                    setdaterange();
                  },
                  icon: const Icon(
                    Icons.calendar_today,
                    // color: kdskyblue,
                  ))
            ],
          ),
          preferredSize: const Size(double.infinity, 50),
        ),
        body: Obx(() {
          UserWorkReport reportdata = callerpagectrl!.userworkdetails.value;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 10, left: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "${logeduserctrl!.logeduserdetail.value.logeduserName} (${logeduserctrl!.logeduserdetail.value.logeduserId})"
                              .text
                              .color(Get.theme.colorScheme.secondary)
                              .fontFamily('PoppinsSemiBold')
                              .size(18)
                              .overflow(TextOverflow.fade)
                              .make(),
                          "${logeduserctrl!.logeduserdetail.value.compName} (${logeduserctrl!.logeduserdetail.value.compId})"
                              .text
                              .color(Get.theme.colorScheme.onSecondary)
                              .fontFamily('PoppinsSemiBold')
                              .size(14)
                              .overflow(TextOverflow.fade)
                              .make(),
                          logeduserctrl!
                              .logeduserdetail.value.logeduserPost.text
                              .color(Get.theme.colorScheme.primary)
                              .fontFamily('PoppinsSemiBold')
                              .size(14)
                              .make(),
                          logeduserctrl!
                              .logeduserdetail.value.logeduserDepartment!
                              .join(', ')
                              .text
                              .color(Get.theme.colorScheme.onSecondary)
                              .fontFamily('PoppinsSemiBold')
                              .size(14)
                              .make(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: kdwhitecolor,
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const Divider(
                  thickness: .9,
                  color: kdwhitecolor,
                  height: 20,
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Work Report"
                              .text
                              .color(Get.theme.colorScheme.onBackground)
                              .fontFamily('PoppinsSemiBold')
                              .size(22)
                              .make(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: TextButton(
                                onPressed: () {
                                  setdaterange();
                                },
                                child:
                                    "(${date_dM(callerpagectrl!.selecteddaterange.start)} To ${date_dM(callerpagectrl!.selecteddaterange.end)})"
                                        .text
                                        .color(Get.theme.colorScheme.primary)
                                        .fontFamily('PoppinsSemiBold')
                                        .make()),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (callerpagectrl!.issearching.value)
                        buildLinerloading(),
                      if (!callerpagectrl!.issearching.value)
                        Column(
                          children: [
                            buildworkcard(
                                lable: 'Working Hrs',
                                detail:
                                    '${reportdata.workingHrs ?? '0'} Hrs, ${reportdata.workingMin ?? '0'} Min'),
                            buildworkcard(
                                lable: 'Avg. Working Hrs',
                                detail: '${reportdata.avgWorking ?? '0'} Hrs.'),
                            // buildworkcard(
                            //     lable: 'Absents',
                            //     detail: '${reportdata.absents ?? '0'} Absents'),
                            // buildworkcard(
                            //     lable: 'Half',
                            //     detail: '${reportdata.half ?? '0'} Half'),
                            // buildworkcard(
                            //     lable: 'Short Login',
                            //     detail:
                            //         '${reportdata.shortLogin ?? '0'} Short'),
                            buildworkcard(
                                lable: 'Used Leads',
                                detail: '${reportdata.usedLeads ?? '0'} Leads'),
                            buildworkcard(
                                lable: 'Total Calls',
                                detail:
                                    '${reportdata.totalResponses ?? '0'} Calls'),
                          ],
                        ),
                      if (reportdata.departResponse.isNotEmpty)
                        Column(
                          children: [
                            categorydivider(),
                            ListView.builder(
                                itemCount: reportdata.departResponse.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  List<String> _break = reportdata
                                      .departResponse[index]
                                      .split('@@');
                                  return buildworkcard(
                                      lable: _break[0],
                                      detail: '${_break[1]} Leads');
                                }),
                          ],
                        ),
                      if (reportdata.responseCateg.isNotEmpty)
                        Column(
                          children: [
                            categorydivider(),
                            ListView.builder(
                                itemCount: reportdata.responseCateg.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  List<String> _break = reportdata
                                      .responseCateg[index]
                                      .split('@@');
                                  return buildworkcard(
                                      lable: _break[0],
                                      detail: '${_break[1]} Leads');
                                }),
                          ],
                        ),
                      if (reportdata.leadDetail.isNotEmpty)
                        Column(
                          children: [
                            categorydivider(),
                            ListView.builder(
                                itemCount: reportdata.leadDetail.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  List<String> _break =
                                      reportdata.leadDetail[index].split('@@');
                                  return buildworkcard(
                                      lable: _break[0],
                                      detail: '${_break[1]} Leads');
                                }),
                          ],
                        ),
                      if (reportdata.openCloseLead.isNotEmpty)
                        Column(
                          children: [
                            categorydivider(),
                            ListView.builder(
                                itemCount: reportdata.openCloseLead.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  List<String> _break = reportdata
                                      .openCloseLead[index]
                                      .split('@@');
                                  return buildworkcard(
                                      lable: _break[0],
                                      detail: '${_break[1]} Leads');
                                }),
                          ],
                        ),
                      if (reportdata.successFailLead.isNotEmpty)
                        Column(
                          children: [
                            categorydivider(),
                            ListView.builder(
                                itemCount: reportdata.successFailLead.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  List<String> _break = reportdata
                                      .successFailLead[index]
                                      .split('@@');
                                  return buildworkcard(
                                      lable: _break[0],
                                      detail: '${_break[1]} Leads');
                                }),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildworkcard({
    required String lable,
    required String detail,
  }) {
    double textsize = 14;
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: lable.text
                .color(Get.theme.colorScheme.primary)
                .fontFamily('PoppinsSemiBold')
                .size(textsize)
                .heightLoose
                .make()),
        SizedBox(
          width: 15,
          child: ":"
              .text
              .color(Get.theme.colorScheme.onBackground)
              .fontFamily('PoppinsSemiBold')
              .size(textsize)
              .makeCentered(),
        ),
        Expanded(
            flex: 5,
            child: detail.text
                .color(Get.theme.colorScheme.secondary)
                .fontFamily('PoppinsSemiBold')
                .overflow(TextOverflow.fade)
                .size(textsize)
                .make()),
      ],
    );
  }

  Widget categorydivider() {
    return const Divider(
      thickness: .5,
      color: kdaccentcolor,
      endIndent: 10,
    );
  }
}
