import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/extensions/widget_ext.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/models/leads/leadresponse_model.dart';
import 'package:callingpanel/models/oneleadhistory_model.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelines/timelines.dart';
import 'callhistory_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class FullCallHistoryWeb extends StatefulWidget {
  const FullCallHistoryWeb({Key? key}) : super(key: key);

  @override
  _FullCallHistoryWebState createState() => _FullCallHistoryWebState();
}

CallHistoryWebCtrl? callhistorywebctrl;

class _FullCallHistoryWebState extends State<FullCallHistoryWeb> {
  @override
  void initState() {
    callhistorywebctrl = Get.find<CallHistoryWebCtrl>();
    callhistorywebctrl!.getcalllogweb();
    super.initState();
  }

  @override
  void dispose() {
    callhistorywebctrl!.showfullhistoryof.value = LeadResponse();
    callhistorywebctrl!.callloglist.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15),
      // physics: NeverScrollableScrollPhysics(),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: callhistorywebctrl!.issearching.value,
                  child: buildLinerloading()),
              const SizedBox(
                height: 5,
              ),
              buildLeaddetail(),
              Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                    itemCount: callhistorywebctrl!.callloglist.length,
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildtimelinecard(
                        index: index,
                        totalcards: callhistorywebctrl!.callloglist.length,
                        oneLeadCallLog: callhistorywebctrl!.callloglist[index],
                      );
                    }),
              ).custumScrollBehaviour,
            ],
          )),
    );
  }

  Widget buildLeaddetail() {
    LeadResponse userdata = callhistorywebctrl!.showfullhistoryof.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Get.find<WorkPageController>()
                      .setworkpage(PageSwitch.callhistory);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  // color: kdwhitecolor,
                  size: 24,
                )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        textwithicon(
            textvalue: "${userdata.fullName}",
            fontsize: 24,
            icondata: Icons.person),
        textwithicon(
            textvalue: "${userdata.department}", icondata: Icons.engineering),
        textwithicon(
          textvalue: "${userdata.mobile}, ${userdata.altMobile}",
          icondata: Icons.phone,
          fontsize: 22,
        ),
        textwithicon(textvalue: "${userdata.email}", icondata: Icons.email),
        textwithicon(
            textvalue:
                "${userdata.country} > ${userdata.state} > ${userdata.city}",
            fontsize: 16,
            icondata: Icons.place),
        const SizedBox(
          height: 40,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: "Call Logs"
              .text
              .color(Get.theme.colorScheme.onSecondary)
              .size(26)
              .align(TextAlign.start)
              .make(),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget buildtimelinecard({
    required int totalcards,
    required int index,
    required OneLeadCallLog oneLeadCallLog,
  }) {
    String meetingdate = oneLeadCallLog.intdate ?? '';
    if (meetingdate != '') {
      meetingdate = " ($meetingdate)";
    }
    List<String> datesplit = oneLeadCallLog.showdate!.split('-');

    return TimelineTile(
        nodeAlign: TimelineNodeAlign.start,
        node: TimelineNode(
          indicator: CircleAvatar(
            radius: 60,
            backgroundColor: Get.theme.colorScheme.surface,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    datesplit[0],
                    style: const TextStyle(
                        fontSize: 18, fontFamily: 'PoppinsSemiBold'),
                  ),
                  Text(
                    datesplit[1],
                    style: const TextStyle(
                        fontSize: 16, fontFamily: 'PoppinsSemiBold'),
                  ),
                  Text(
                    oneLeadCallLog.showtime ?? '',
                    style: const TextStyle(
                        fontSize: 12, fontFamily: 'PoppinsSemiBold'),
                  ),
                ],
              ),
            ),
          ),
          startConnector: index == 0
              ? const SizedBox()
              : const SolidLineConnector(
                  color: kdaccentcolor,
                ),
          endConnector: ((index + 1) == totalcards)
              ? const SizedBox()
              : const SolidLineConnector(
                  color: kdaccentcolor,
                ),
        ),
        contents: Container(
          // color: Get.theme.colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 125,
          child: Card(
            elevation: 20,
            color: Get.theme.colorScheme.surface,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildtiteltext(
                      text:
                          'Response    : ${oneLeadCallLog.response} ${oneLeadCallLog.intdate}'),
                  buildtiteltext(text: '${oneLeadCallLog.priority}'),
                ],
              ),
              subtitle: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildtiteltext(
                          text: 'Remark       : ${oneLeadCallLog.remark}'),
                      buildtiteltext(text: '${oneLeadCallLog.leadresult}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildtiteltext(
                          text:
                              'UpdateBy   : ${callhistorywebctrl!.showfullhistoryof.value.lastUpdateName} (${oneLeadCallLog.updateby})'),
                      buildtiteltext(
                          text: 'Duration  : ${oneLeadCallLog.showduration}'),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: () async {
                  //         if (oneLeadCallLog.recordingid == "") {
                  //           showsnackbar(
                  //               titel: 'Failed !!!',
                  //               detail: 'Recording not available...');
                  //         } else {
                  //           String reult = await getaudiourlbyid(
                  //               fileid: oneLeadCallLog.recordingid ?? "");
                  //           if (reult.contains("http")) {
                  //             launch.launch(reult);
                  //           } else {
                  //             showsnackbar(
                  //                 titel: "Failed !!!",
                  //                 detail: "Failed to play recording...");
                  //           }
                  //         }
                  //       },
                  //       child: buildtiteltext(
                  //           textcolor: oneLeadCallLog.recordingid == ''
                  //               ? Constants.kdred
                  //               : kdgreencolor,
                  //           text: 'Recording  : Play Recording'),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}

Widget buildtiteltext({
  required String text,
  Color? textcolor,
}) {
  return Text(
    text,
    style: TextStyle(
      color: textcolor ?? kdfbblue,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget textwithicon({
  required String textvalue,
  IconData? icondata,
  double? fontsize,
  double? iconsize,
  Color? fontcolor,
}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if (icondata != null)
        Icon(
          icondata,
          // color: kdskyblue,
          size: iconsize ?? 18,
        ),
      if (icondata != null)
        const SizedBox(
          width: 5,
        ),
      textvalue.text
          .color(fontcolor ?? kdfbblue)
          .size(fontsize ?? 18)
          .heightLoose
          .fontWeight(FontWeight.w600)
          .makeCentered(),
    ],
  );
}
