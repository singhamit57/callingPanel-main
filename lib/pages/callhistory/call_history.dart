import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/extensions/widget_ext.dart';
import 'package:callingpanel/functions/audi_player.dart';
import 'package:callingpanel/functions/donload_file.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mini_widgets.dart/nodatafound_lottie.dart';
import 'package:callingpanel/mini_widgets.dart/searchingdata_lottie.dart';
import 'package:callingpanel/models/leads/leadresponse_model.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'callhistory_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({Key? key}) : super(key: key);

  @override
  _CallHistoryPageState createState() => _CallHistoryPageState();
}

CallHistoryWebCtrl? callHistoryWebCtrl;
Appbarcontroller? appbarcontroller;
ScrollController? listscrollcrtl;
var isrequested = false.obs;

class _CallHistoryPageState extends State<CallHistoryPage> {
  ScrollController scrlCtrl = ScrollController();

  @override
  void dispose() {
    appbarcontroller!.daterangevisible.value = false;
    appbarcontroller!.downloadvisible.value = false;
    appbarcontroller!.searchvisible.value = false;

    super.dispose();
  }

  @override
  void initState() {
    callHistoryWebCtrl = Get.find<CallHistoryWebCtrl>();
    appbarcontroller = Get.find<Appbarcontroller>();
    listscrollcrtl = ScrollController();
    listscrollcrtl!.addListener(() {
      scrollListener();
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appbarcontroller!.daterangevisible.value = true;
      appbarcontroller!.downloadvisible.value = true;
      appbarcontroller!.searchvisible.value = true;
      appbarcontroller!.downloadTip.value = 'Download this record.';
      // callHistoryWebCtrl!.getreponsehistryweb(pagenumber: 0);
    });
    super.initState();
  }

  launchrecording(
      {required String id,
      required int index,
      required String currentstatus,
      required String currentpath}) async {
    // callHistoryWebCtrl!.responsehistoryshow[index].recordingstatus =
    //     "Downloading";
    // setState(() {});
    String reult = await getaudiourlbyid(fileid: id);
    if (kIsWeb) {
      String fileName = reult.substring(reult.lastIndexOf("/") + 1);
      reult = mainurl + '/uploadfiles/downloadfile.php?name=$fileName';
    }
    if (reult.contains("http")) {
      // callHistoryWebCtrl!.responsehistoryshow[index].recordingstatus =
      //     "Downloaded";
      // callHistoryWebCtrl!.responsehistoryshow[index].downloadedpath = reult;
      // setState(() {});
      downloadFileByUrl(url: reult);
      // launch.launch(reult);
    } else {
      callHistoryWebCtrl!.responsehistoryshow[index].recordingstatus = "Failed";
      // setState(() {});
      showsnackbar(titel: "Failed !!!", detail: "Failed to play recording...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Column(
              children: [
                Visibility(
                    visible: (callHistoryWebCtrl!.issearching.value),
                    child: buildLinerloading()),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: ("Call History")
                                .text
                                .xl4
                                .color(Get.theme.colorScheme.onSecondary)
                                .fontFamily('PoppinsSemiBold')
                                .make())),
                    Visibility(
                      visible:
                          (callHistoryWebCtrl!.responsehistoryshow.isNotEmpty &&
                              !isrequested.value),
                      child:
                          ("${callHistoryWebCtrl!.responsehistoryshow.length} Out Of ${callHistoryWebCtrl!.totalavaildata}")
                              .toString()
                              .text
                              .color(Get.theme.colorScheme.onSecondary
                                  .withOpacity(.7))
                              .size(14)
                              .make(),
                    ),
                    Visibility(
                      visible: (isrequested.value),
                      child: ("Loading...")
                          .toString()
                          .text
                          .color(
                              Get.theme.colorScheme.onSecondary.withOpacity(.7))
                          .size(14)
                          .make(),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              controller: listscrollcrtl,
              child: Column(
                children: [
                  Visibility(
                      visible:
                          (callHistoryWebCtrl!.responsehistoryshow.isEmpty &&
                              callHistoryWebCtrl!.issearching.value),
                      child: buildsearchingdatalottie()),
                  Visibility(
                      visible:
                          (callHistoryWebCtrl!.responsehistoryshow.isEmpty &&
                              !callHistoryWebCtrl!.issearching.value),
                      child: buildnodatlottie()),
                  Visibility(
                    visible: callHistoryWebCtrl!.responsehistoryshow.isNotEmpty,
                    child: Scrollbar(
                      controller: scrlCtrl,
                      child: ListView.builder(
                          controller: scrlCtrl,
                          itemCount:
                              callHistoryWebCtrl!.responsehistoryshow.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return buildonehistorycard(
                              index: index,
                              onedata: callHistoryWebCtrl!
                                  .responsehistoryshow[index],
                              context: context,
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ).custumScrollBehaviour),
          ],
        ));
  }

  Widget buildonehistorycard(
      {required int index, required context, required LeadResponse onedata}) {
    Color _stripcolor = Get.theme.colorScheme.primary;
    if (onedata.priority == 'Hot Lead') {
      _stripcolor = kdskyblue;
    }
    if (onedata.priority == 'Medium Lead') {
      _stripcolor = kdyellowcolor;
    }
    if (onedata.priority == 'Cold Lead') {
      _stripcolor = Constants.kdred;
    }
    String meetingdate = "";
    if (onedata.intdateshow != "") {
      meetingdate = " (${onedata.intdateshow})";
    }
    return InkWell(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => FullCallHistoryWeb()));
        callHistoryWebCtrl!.showfullhistoryof.value = onedata;
        Get.find<WorkPageController>().setworkpage(PageSwitch.fullcallhistory);
      },
      child: Card(
        elevation: 10,
        color: kdfbblue,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              // color: Get.theme.primaryColorDark,
              border: Border(left: BorderSide(color: _stripcolor, width: 3))),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: buildtiteltext(
                        value: '${onedata.fullName} (${onedata.department})',
                        icon: Icons.person,
                      )),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: buildtiteltext(
                        icon: Icons.edit,
                        value: '${onedata.response} $meetingdate'),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: buildtiteltext(
                          icon: Icons.calendar_today,
                          value: '${onedata.showdate}')),
                ),
              ],
            ),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: buildsubtiteltext(
                              icon: Icons.phone,
                              value:
                                  '${onedata.mobile}, ${nullcheck(onedata.altMobile)}')),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: buildsubtiteltext(
                              icon: Icons.badge,
                              value:
                                  '${onedata.lastUpdateName} (${onedata.userid})')),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: buildsubtiteltext(
                            icon: Icons.schedule,
                            value:
                                "${nullcheck(onedata.showtime)} (${nullcheck(onedata.showDuration)})"),
                      ),
                    ),
                  ],
                ),
                //row 2
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: buildsubtiteltext(
                              icon: Icons.alternate_email,
                              value: nullcheck(onedata.email))),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: buildsubtiteltext(
                              icon: Icons.equalizer,
                              value: nullcheck(onedata.priority))),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: buildsubtiteltext(
                            icon: Icons.list,
                            value: nullcheck(onedata.leadResult)),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: buildsubtiteltext(
                              icon: Icons.note_alt,
                              value: nullcheck(onedata.remark))),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: buildsubtiteltext(
                              icon: Icons.code,
                              value: nullcheck(onedata.dataCode))),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     alignment: Alignment.centerLeft,
                    //     child: InkWell(
                    //       onTap: () {
                    //         if (onedata.recordingid == "") {
                    //           showsnackbar(
                    //               titel: 'Failed !!!',
                    //               detail: 'Recording not available...');
                    //         } else {
                    //           launchrecording(
                    //               id: onedata.recordingid ?? "",
                    //               currentstatus: onedata.recordingstatus ?? "",
                    //               currentpath: onedata.downloadedpath ?? "",
                    //               index: index);
                    //         }
                    //       },
                    //       child: buildsubtiteltext(
                    //           icon: Icons.play_circle,
                    //           iconcolor: (onedata.recordingid == "")
                    //               ? Constants.kdred
                    //               : kdgreencolor,
                    //           value: onedata.recordingstatus!),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildtiteltext({
  required String value,
  IconData? icon,
  double? txtsize,
}) {
  return value.isEmpty
      ? const SizedBox()
      : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null)
              Icon(
                icon,
                // color: kdskyblue,
              ),
            if (icon != null)
              const SizedBox(
                width: 5,
              ),
            (value)
                .text
                .color(kdwhitecolor)
                .size(18)
                .fontWeight(FontWeight.w500)
                .make()
          ],
        );
}

Widget buildsubtiteltext({
  required String value,
  IconData? icon,
  Color? iconcolor,
  Color? textcolor,
  double? txtsize,
}) {
  return value.isEmpty
      ? const SizedBox()
      : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: iconcolor,
              ),
            if (icon != null)
              const SizedBox(
                width: 5,
              ),
            Expanded(
                child: (value)
                    .text
                    .color(textcolor ?? kdwhitecolor)
                    .size(txtsize ?? 14)
                    .fontWeight(FontWeight.w500)
                    .make())
          ],
        );
}

String nullcheck(value) {
  if (value == null || value == 'NA' || value == 'null') {
    return "";
  } else {
    return value.toString();
  }
}

scrollListener() async {
  // print(listscrollcrtl.offset);
  // print(listscrollcrtl.position.maxScrollExtent);
  // print(listscrollcrtl.position.outOfRange);
  double maxscroll = listscrollcrtl!.position.maxScrollExtent;
  double currentscroll = listscrollcrtl!.offset;
  if (currentscroll >= maxscroll * .98 &&
      callHistoryWebCtrl!.totalavailpage >=
          (callHistoryWebCtrl!.nexpagenumber + 1)) {
    if (callHistoryWebCtrl!.responsehistoryshow.isNotEmpty &&
        !isrequested.value) {
      isrequested.value = true;
      await callHistoryWebCtrl!.getreponsehistryweb(
        pagenumber: callHistoryWebCtrl!.nexpagenumber,
      );
      isrequested.value = false;
    }
  }
}
