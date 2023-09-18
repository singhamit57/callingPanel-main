import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/mini_widgets.dart/searchingdata_lottie.dart';
import 'package:callingpanel/pages/callhistory/callhistory_controller.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../mini_widgets.dart/linearloding_widget.dart';
import 'package:get/get.dart';

import 'callerworkreport_controller.dart';

class CallerWorkReportWeb extends StatefulWidget {
  const CallerWorkReportWeb({
    Key? key,
  }) : super(key: key);

  @override
  _CallerWorkReportWebState createState() => _CallerWorkReportWebState();
}

CallerWorkReportWebCtrl? callerWorkReportWebCtrl;
Appbarcontroller? appbarcontroller;

ScrollController scrollController = ScrollController();

class _CallerWorkReportWebState extends State<CallerWorkReportWeb> {
  @override
  void dispose() {
    callerWorkReportWebCtrl!.gotreportdata.value = blankreportdata;
    appbarcontroller!.daterangevisible.value = false;
    super.dispose();
  }

  @override
  void initState() {
    callerWorkReportWebCtrl = Get.find<CallerWorkReportWebCtrl>();
    appbarcontroller = Get.find<Appbarcontroller>();
    callerWorkReportWebCtrl!.getworkdetails(operation: "Admininit");
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      appbarcontroller!.daterangevisible.value = true;
    });
    super.initState();
  }

  navigateToCallHistory({
    required String operation,
  }) {
    Get.find<WorkPageController>().setworkpage(PageSwitch.callhistory);
    Get.find<CallHistoryWebCtrl>().getreponsehistryweb(
        pagenumber: 0,
        searchForId: callerWorkReportWebCtrl!.userid,
        operation: "operation");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 50),
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      child: Obx(() {
        final reportdata = callerWorkReportWebCtrl!.gotreportdata;
        return Container(
          color: kdwhitecolor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Work Report".text.color(kdfbblue).size(26).make(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (callerWorkReportWebCtrl!.issearching.value)
                buildLinerloading(),
              Visibility(
                visible: (!callerWorkReportWebCtrl!.issearching.value),
                child: Row(
                  children: [
                    reportchip(text: "Today"),
                    reportchip(text: "Yesterday"),
                    reportchip(text: "Last 7 Day's"),
                    reportchip(text: "Last 30 Day's"),
                    Visibility(
                        visible:
                            callerWorkReportWebCtrl!.customrangereport.value !=
                                "",
                        child: reportchip(
                            text: callerWorkReportWebCtrl!
                                .customrangereport.value)),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (callerWorkReportWebCtrl!.issearching.value)
                buildsearchingdatalottie(),
              if (!callerWorkReportWebCtrl!.issearching.value)
                Column(
                  children: [
                    buildworkcard(
                        lable: 'Working Hrs',
                        detail:
                            '${reportdata.value.workingHrs ?? '0'} Hrs, ${reportdata.value.workingMin ?? '0'} Min'),
                    buildworkcard(
                        lable: 'Avg. Working Hrs',
                        detail: '${reportdata.value.avgWorking ?? '0'} Hrs.'),
                    // buildworkcard(
                    //     lable: 'Absents',
                    //     detail: '${reportdata.value.absents ?? '0'} Absents'),
                    // buildworkcard(
                    //     lable: 'Half',
                    //     detail: '${reportdata.value.half ?? '0'} Half'),
                    // buildworkcard(
                    //     lable: 'Short Login',
                    //     detail: '${reportdata.value.shortLogin ?? '0'} Short'),
                    InkWell(
                      onTap: () {
                        navigateToCallHistory(operation: "UsedLeads");
                      },
                      child: buildworkcard(
                          lable: 'Used Leads',
                          detail: '${reportdata.value.usedLeads ?? '0'} Leads'),
                    ),
                    InkWell(
                      onTap: () {
                        navigateToCallHistory(operation: "TotalCalls");
                      },
                      child: buildworkcard(
                          lable: 'Total Calls',
                          detail:
                              '${reportdata.value.totalResponses ?? '0'} Calls'),
                    ),
                  ],
                ),
              if (reportdata.value.departResponse.isNotEmpty &&
                  !callerWorkReportWebCtrl!.issearching.value)
                Column(
                  children: [
                    categorydivider(),
                    ListView.builder(
                        itemCount: reportdata.value.departResponse.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          List<String> _break = reportdata
                              .value.departResponse[index]
                              .split('@@');
                          return InkWell(
                            onTap: () {
                              navigateToCallHistory(
                                  operation: "${_break[0]}@@DepartResponse");
                            },
                            child: buildworkcard(
                                lable: _break[0], detail: '${_break[1]} Leads'),
                          );
                        }),
                  ],
                ),
              if (reportdata.value.responseCateg.isNotEmpty &&
                  !callerWorkReportWebCtrl!.issearching.value)
                Column(
                  children: [
                    categorydivider(),
                    ListView.builder(
                        itemCount: reportdata.value.responseCateg.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          List<String> _break =
                              reportdata.value.responseCateg[index].split('@@');
                          return InkWell(
                            onTap: () {
                              navigateToCallHistory(
                                  operation: "${_break[0]}@@ResponseCategory");
                            },
                            child: buildworkcard(
                                lable: _break[0], detail: '${_break[1]} Leads'),
                          );
                        }),
                  ],
                ),
              if (reportdata.value.leadDetail.isNotEmpty &&
                  !callerWorkReportWebCtrl!.issearching.value)
                Column(
                  children: [
                    categorydivider(),
                    ListView.builder(
                        itemCount: reportdata.value.leadDetail.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          List<String> _break =
                              reportdata.value.leadDetail[index].split('@@');
                          return InkWell(
                            onTap: () {
                              navigateToCallHistory(
                                  operation: "${_break[0]}@@LeadDetails");
                            },
                            child: buildworkcard(
                                lable: _break[0], detail: '${_break[1]} Leads'),
                          );
                        }),
                  ],
                ),
              if (reportdata.value.openCloseLead.isNotEmpty &&
                  !callerWorkReportWebCtrl!.issearching.value)
                Column(
                  children: [
                    categorydivider(),
                    ListView.builder(
                        itemCount: reportdata.value.openCloseLead.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          List<String> _break =
                              reportdata.value.openCloseLead[index].split('@@');
                          return InkWell(
                            onTap: () {
                              navigateToCallHistory(
                                  operation: "${_break[0]}@@OpenClosed");
                            },
                            child: buildworkcard(
                                lable: _break[0], detail: '${_break[1]} Leads'),
                          );
                        }),
                  ],
                ),
              if (reportdata.value.successFailLead.isNotEmpty &&
                  !callerWorkReportWebCtrl!.issearching.value)
                Column(
                  children: [
                    categorydivider(),
                    ListView.builder(
                        itemCount: reportdata.value.successFailLead.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          List<String> _break = reportdata
                              .value.successFailLead[index]
                              .split('@@');
                          return InkWell(
                            onTap: () {
                              navigateToCallHistory(
                                  operation: "${_break[0]}@@SuccessFaild");
                            },
                            child: buildworkcard(
                                lable: _break[0], detail: '${_break[1]} Leads'),
                          );
                        }),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget reportchip({
    required String text,
  }) {
    return InkWell(
      onTap: () {
        if (callerWorkReportWebCtrl!.selectedchip.value == text) {
          return;
        } else {
          callerWorkReportWebCtrl!.customrangereport.value = "";
        }
        callerWorkReportWebCtrl!.selectedchip.value = text;
        callerWorkReportWebCtrl!.getworkdetails(operation: "callreport_$text");
      },
      child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Obx(
            () {
              bool _slected =
                  callerWorkReportWebCtrl!.selectedchip.value == text;
              return Chip(
                  elevation: 15,
                  // labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  backgroundColor: _slected
                      ? kdwhitecolor
                      : Get.theme.primaryColorDark.withOpacity(.2),
                  shadowColor: Get.theme.primaryColor,
                  side: BorderSide(
                      color: kdgreencolor.withOpacity(.6), width: 1.5),
                  label: (text)
                      .text
                      .fontWeight(
                          _slected ? FontWeight.bold : FontWeight.normal)
                      .size(14)
                      .color(_slected ? kdfbblue : kdblackcolor)
                      .make());
            },
          )),
    );
  }
}

Widget buildworkcard({
  required String lable,
  required String detail,
}) {
  double textsize = 16;
  return Row(
    children: [
      Expanded(
          flex: 3, child: lable.text.black.size(textsize).heightLoose.make()),
      SizedBox(
        width: 15,
        child: ":".text.black.size(textsize).makeCentered(),
      ),
      Expanded(
          flex: 5,
          child: detail.text.black
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
