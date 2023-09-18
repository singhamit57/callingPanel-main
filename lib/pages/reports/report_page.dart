import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/pages/leads/leadpage_controll.dart';
import 'package:callingpanel/pages/reports/report_controller.dart';
import 'package:callingpanel/pages/reports/reposrthelper_widget.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

ReportPageCtrl? reportPageCtrl;

class _ReportPageState extends State<ReportPage> {
  ScrollController sctCtrl = ScrollController();

  @override
  void initState() {
    reportPageCtrl = Get.find<ReportPageCtrl>();
    // reportPageCtrl!.getreportcarddetails();
    super.initState();
  }

  openleadpage(String value) {
    Get.find<WorkPageController>().setworkpage(PageSwitch.leads);
    // Get.find<Appbarcontroller>().searchvisible.value = true;
    Get.find<Appbarcontroller>().searchbarctrl.text = '';
    Get.find<LeadPageCtrl>().pagetitel.value = value;
    Get.find<LeadPageCtrl>().filtercategory = value;
    Get.find<LeadPageCtrl>().getleadlist(pagenumber: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: sctCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
                visible: (reportPageCtrl!.issearching.value),
                child: buildLinerloading()),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: "Reports"
                  .text
                  .color(Get.theme.colorScheme.onSecondary)
                  .xl4
                  .fontFamily('PoppinsSemiBold')
                  .makeCentered(),
            ),
            ResponsiveLayout(
              computer: GridView(
                shrinkWrap: true,
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: ResponsiveLayout.isComputer(context)
                        ? 5
                        : ResponsiveLayout.isPhone(context)
                            ? 2
                            : 4),
                children: [
                  buildTotalLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildAvailLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildublicateLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildusedLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildHotLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildMediumLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildColdLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildopenLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildClosedLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildsuccessLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildfailedLeadcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildtotalfollowcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildtodayfollowcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildpendingfollowcard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                  buildcallhistorycard(
                    context: context,
                    controller: reportPageCtrl!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Total leads,
  Widget buildTotalLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.totalleads,
      count: controller.reportcarddetails.value.totalLeads,
      lableColor: cardcolors[0],
      ontap: () {
        openleadpage(ReportCardlable.totalleads);
      },
      context: context,
    );
  }

  //Availbale leads
  Widget buildAvailLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.availbaleleads,
      count: controller.reportcarddetails.value.availableLeads,
      lableColor: cardcolors[1],
      ontap: () {
        openleadpage(ReportCardlable.availbaleleads);
      },
      context: context,
    );
  }

  ///Dublicate leads
  Widget buildublicateLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.dublicateleads,
      count: controller.reportcarddetails.value.dublicatieLeads,
      lableColor: cardcolors[2],
      ontap: () {
        openleadpage(ReportCardlable.dublicateleads);
      },
      context: context,
    );
  }

  ///Used leads
  Widget buildusedLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.usedleads,
      count: controller.reportcarddetails.value.usedLeads,
      lableColor: cardcolors[3],
      ontap: () {
        openleadpage(ReportCardlable.usedleads);
      },
      context: context,
    );
  }

  //hot leads
  Widget buildHotLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.hotleads,
      count: controller.reportcarddetails.value.hotLeads,
      lableColor: cardcolors[4],
      ontap: () {
        openleadpage(ReportCardlable.hotleads);
      },
      context: context,
    );
  }

  //medium leads
  Widget buildMediumLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.mediumleads,
      count: controller.reportcarddetails.value.mediumLeads,
      lableColor: cardcolors[5],
      ontap: () {
        openleadpage(ReportCardlable.mediumleads);
      },
      context: context,
    );
  }

  //cold leads
  Widget buildColdLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.coldleads,
      count: controller.reportcarddetails.value.coldLeads,
      lableColor: cardcolors[6],
      ontap: () {
        openleadpage(ReportCardlable.coldleads);
      },
      context: context,
    );
  }

  //Open leads
  Widget buildopenLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.openleads,
      count: controller.reportcarddetails.value.openLeads,
      lableColor: cardcolors[7],
      ontap: () {
        openleadpage(ReportCardlable.openleads);
      },
      context: context,
    );
  }

  //closed leads
  Widget buildClosedLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.closedleads,
      count: controller.reportcarddetails.value.closedLeads,
      lableColor: cardcolors[8],
      ontap: () {
        openleadpage(ReportCardlable.closedleads);
      },
      context: context,
    );
  }

  //success leads
  Widget buildsuccessLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.successleads,
      count: controller.reportcarddetails.value.successLeads,
      lableColor: cardcolors[9],
      ontap: () {
        openleadpage(ReportCardlable.successleads);
      },
      context: context,
    );
  }

  //failed leads
  Widget buildfailedLeadcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.failedleads,
      count: controller.reportcarddetails.value.failedLeads,
      lableColor: cardcolors[10],
      ontap: () {
        openleadpage(ReportCardlable.failedleads);
      },
      context: context,
    );
  }

  //total follow
  Widget buildtotalfollowcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.totalfollowups,
      count: controller.reportcarddetails.value.totalFollowups,
      lableColor: cardcolors[11],
      ontap: () {
        openleadpage(ReportCardlable.totalfollowups);
      },
      context: context,
    );
  }

  //today follow
  Widget buildtodayfollowcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.todayfollowups,
      count: controller.reportcarddetails.value.todayFollowups,
      lableColor: cardcolors[12],
      ontap: () {
        openleadpage(ReportCardlable.todayfollowups);
      },
      context: context,
    );
  }

  //pending follow
  Widget buildpendingfollowcard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.pendingfollowups,
      count: controller.reportcarddetails.value.pendingFollowups,
      lableColor: cardcolors[13],
      ontap: () {
        openleadpage(ReportCardlable.pendingfollowups);
      },
      context: context,
    );
  }

  //call history
  Widget buildcallhistorycard({
    required context,
    required ReportPageCtrl controller,
  }) {
    return buildreportcard(
      lable: ReportCardlable.callhistory,
      count: controller.reportcarddetails.value.callHistory,
      lableColor: cardcolors[14],
      ontap: () {
        Get.find<WorkPageController>().setworkpage(PageSwitch.callhistory);
      },
      context: context,
    );
  }
}





/*
Column(
                children: [
                  buildonerow(
                    leftwidget: buildTotalLeadcard(
                      context: context,
                      controller: reportPageCtrl!,
                    ),
                    centerwidget: buildAvailLeadcard(
                      context: context,
                      controller: reportPageCtrl!,
                    ),
                    righttwidget: buildublicateLeadcard(
                      context: context,
                      controller: reportPageCtrl!,
                    ),
                  ),
                  buildonerow(
                    leftwidget: buildHotLeadcard(
                      context: context,
                      controller: reportPageCtrl!,
                    ),
                    centerwidget: buildMediumLeadcard(
                      context: context,
                      controller: reportPageCtrl!,
                    ),
                    righttwidget: buildColdLeadcard(
                      context: context,
                      controller: reportPageCtrl!,
                    ),
                  ),
                ],
              ),

*/