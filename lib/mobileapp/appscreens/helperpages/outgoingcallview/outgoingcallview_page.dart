import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

import 'outgoingcallview_controller.dart';

class OutgoinCallViewPage extends StatefulWidget {
  final String? fullname;
  final String mobile;
  final bool? isrecording;
  final String frompagename;
  final String leadId;
  final String? imagepath;
  const OutgoinCallViewPage({
    Key? key,
    this.fullname,
    required this.mobile,
    this.isrecording,
    required this.frompagename,
    required this.leadId,
    this.imagepath,
  }) : super(key: key);

  @override
  _OutgoinCallViewPageState createState() => _OutgoinCallViewPageState();
}

OutgoincallviewCtrl? outgoincallviewCtrl;
LogeduserControll? logeduserControll;

class _OutgoinCallViewPageState extends State<OutgoinCallViewPage> {
  bool ispickedfile = false;
  @override
  void initState() {
    outgoincallviewCtrl = Get.find<OutgoincallviewCtrl>();
    logeduserControll = Get.find<LogeduserControll>();
    logeduserControll!.currnetworkname = "onoutgoingcall";

    super.initState();
  }

  @override
  void dispose() {
    outgoincallviewCtrl!.timer?.cancel();
    outgoincallviewCtrl!.minutes.value = 0;
    outgoincallviewCtrl!.secounds.value = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Get.theme.colorScheme.primary,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: kdwhitecolor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            widget.imagepath ?? "assets/icons/agcallerlogo.png",
                            fit: BoxFit.cover,
                            height: 110,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ((widget.fullname == null || widget.fullname == "")
                            ? "Unknown"
                            : widget.fullname.toString())
                        .text
                        .color(kdwhitecolor)
                        .size(24)
                        .overflow(TextOverflow.ellipsis)
                        .makeCentered(),
                    (widget.mobile)
                        .text
                        .color(kdwhitecolor)
                        .size(26)
                        .overflow(TextOverflow.ellipsis)
                        .makeCentered(),
                    Obx(() {
                      String showmin = (outgoincallviewCtrl!.minutes < 10)
                          ? "0${outgoincallviewCtrl!.minutes}"
                          : "${outgoincallviewCtrl!.minutes}";
                      String showsec = (outgoincallviewCtrl!.secounds < 10)
                          ? "0${outgoincallviewCtrl!.secounds}"
                          : "${outgoincallviewCtrl!.secounds}";
                      return "$showmin:$showsec"
                          .text
                          .color(Colors.orange)
                          .size(26)
                          .overflow(TextOverflow.ellipsis)
                          .makeCentered();
                    }),
                    // "Recording"
                    //     .text
                    //     .color(widget.isrecording ?? true
                    //         ? kdgreencolor
                    //         : Constants.kdred)
                    //     .size(26)
                    //     .overflow(TextOverflow.ellipsis)
                    //     .makeCentered(),
                  ],
                )),
                // Align(
                //   alignment: Alignment.center,
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     // onLongPress: () async {
                //     //   outgoincallviewCtrl!.totalcallduration =
                //     //       outgoincallviewCtrl!.durationinsec;
                //     //   outgoincallviewCtrl!.isendedcall.value = false;
                //     //   if (outgoincallviewCtrl!.durationinsec > 3 &&
                //     //       outgoincallviewCtrl!.durationinsec < 2400) {
                //     //     // stopAudiRecord(
                //     //     //     uploadfile: true,
                //     //     //     callRecordingID: outgoincallviewCtrl!.uniquecallId);
                //     //     ispickedfile = await pickaudiofile(
                //     //         uploadfile: true,
                //     //         callRecordingID: outgoincallviewCtrl!.uniquecallId);
                //     //     outgoincallviewCtrl!.isrecording.value = false;
                //     //   }
                //     //   outgoincallviewCtrl!.timer?.cancel();
                //     //   updatecallstamp(
                //     //     operation: "End",
                //     //     leadid: widget.leadId,
                //     //   );
                //     //   if (ispickedfile) {
                //     //     Navigator.pop(context);
                //     //   } else {
                //     //     showsnackbar(
                //     //         titel: 'Alert !!!',
                //     //         detail: 'Please select call recording...');
                //     //   }
                //     // },
                //     child: Obx(() => CircleAvatar(
                //           radius: 35,
                //           backgroundColor:
                //               outgoincallviewCtrl!.isendedcall.value
                //                   ? kdgreencolor
                //                   : Constants.kdred,
                //           child: const Icon(
                //             Icons.call_end,
                //             color: kdwhitecolor,
                //             size: 40,
                //           ),
                //         )),
                //   ),
                // ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
