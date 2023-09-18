import 'package:auto_size_text/auto_size_text.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/functions/make_call.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mini_widgets.dart/nodatafound_lottie.dart';
import 'package:callingpanel/models/leads/leadresponse_model.dart';
import 'package:callingpanel/widgets/reuseable/search_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'callhistory_controll.dart';
import 'fullcallhistory.dart';

CallHistoryCtrl? callHistoryCtrl;
DateTime nowdate = DateTime.now();

class MobileAppCallHistory extends StatefulWidget {
  const MobileAppCallHistory({
    Key? key,
  }) : super(key: key);

  @override
  _MobileAppCallHistoryState createState() => _MobileAppCallHistoryState();
}

class _MobileAppCallHistoryState extends State<MobileAppCallHistory> {
  @override
  void initState() {
    callHistoryCtrl = Get.find<CallHistoryCtrl>();
    callHistoryCtrl!.searchtextctrl.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgrounsColor,
        appBar: AppBar(
          // centerTitle: true,
          title: "Call History"
              .text
              .xl2
              .color(kdwhitecolor)
              .fontFamily('PoppinsSemiBold')
              .make(),
          actions: [
            IconButton(
              onPressed: () {
                showDateRangePicker(
                  context: context,
                  initialDateRange: callHistoryCtrl!.selectedaterange,
                  saveText: "Find",
                  firstDate: DateTime(nowdate.year - 1),
                  lastDate: DateTime(nowdate.year + 1),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData(
                        primaryColor: Get.theme.primaryColorDark,
                        primarySwatch: Colors.brown,
                      ),
                      child: child!,
                    );
                  },
                ).then((value) {
                  if (value != null) {
                    callHistoryCtrl!.selectedaterange = value;
                    callHistoryCtrl!.getreponsehistry();
                  }
                });
              },
              icon: const Icon(Icons.calendar_today),
              color: kdwhitecolor,
            )
          ],
        ),
        body: Obx(
          () {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (callHistoryCtrl!.issearching.value) buildLinerloading(),
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    buildserchbar(),
                    Container(
                      height: 110,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          overalldetailcard(
                              count: callHistoryCtrl!.leadresponsehistory.length
                                  .toString(),
                              lable: 'Total Calls'),
                          ListView.builder(
                              itemCount:
                                  callHistoryCtrl!.distinctresponse.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                String _response =
                                    callHistoryCtrl!.distinctresponse[index];

                                return overalldetailcard(
                                    count: callHistoryCtrl!
                                        .getresponsecount(_response),
                                    lable: _response);
                              }),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: .9,
                      color: Get.theme.colorScheme.onSecondary,
                      indent: 10,
                      endIndent: 2,
                      height: 10,
                    ),
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Visibility(
                          visible:
                              (callHistoryCtrl!.responsehistoryshow.isEmpty &&
                                  !callHistoryCtrl!.issearching.value),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              buildnodatlottie(height: 300, repeat: false),
                              Positioned(
                                bottom: 45,
                                child: ("No History Found")
                                    .text
                                    .size(14)
                                    .color(Get.theme.colorScheme.onSecondary)
                                    .fontFamily('PoppinsSemiBold')
                                    .makeCentered(),
                              ),
                            ],
                          )),

                      // Visibility(
                      //     visible:
                      //         (callHistoryCtrl!.responsehistoryshow.isEmpty &&
                      //             !callHistoryCtrl!.issearching.value),
                      //     child: buildnodatlottie(repeat: false)),

                      ListView.builder(
                          itemCount:
                              callHistoryCtrl!.responsehistoryshow.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return historyonecard(
                                index: index,
                                context: context,
                                onedata: callHistoryCtrl!
                                    .responsehistoryshow[index]);
                          }),
                      // ListView.builder(
                      //     callHistoryCtrl!.responsehistoryshow.length, (index) {
                      //   return historyonecard(
                      //       index: index,
                      //       context: context,
                      //       onedata:
                      //           callHistoryCtrl!.responsehistoryshow[index]);
                      // }),
                    ],
                  ),
                ))
              ],
            );
          },
        ),
      ),
    );
  }

  Widget overalldetailcard({
    required String count,
    required String lable,
  }) {
    bool _selected = callHistoryCtrl!.searchtextctrl.text == lable;
    if (lable == 'Total Calls' && callHistoryCtrl!.searchtextctrl.text == "") {
      _selected = true;
    }
    Color _color = _selected ? Colors.blue : kdblackcolor;
    double _width = _selected ? 2 : 0;
    return GestureDetector(
      onTap: () {
        callHistoryCtrl!.searchtextctrl.text =
            lable == 'Total Calls' ? '' : lable;
        callHistoryCtrl!
            .getsearchresult(callHistoryCtrl!.searchtextctrl.text, true);
        EasyDebounce.cancel('HistoryCaa');
      },
      child: Container(
        height: 80,
        width: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: kdfollow,
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(width: _width, color: _selected ? _color : kdfollow),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            count.text.bold
                .size(24)
                .color(_color)
                .fontWeight(_selected ? FontWeight.bold : FontWeight.normal)
                .makeCentered(),
            const SizedBox(
              height: 5,
            ),
            AutoSizeText(
              (lable.replaceAll(" ", "\n")),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _color,
                fontWeight: _selected ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildserchbar() {
    return SearchWidget(
      hintText: 'Search',
      controller: callHistoryCtrl!.searchtextctrl,
      onChanged: (value) {
        EasyDebounce.debounce('HistoryCaa', const Duration(milliseconds: 800),
            () {
          callHistoryCtrl!.getsearchresult(value, false);
        });
      },
      text: "",
    );
  }

//back medium  text bl;ack
  Widget historyonecard(
      {required int index, required context, required LeadResponse onedata}) {
    // Color _stripcolor = Get.theme.colorScheme.primary.withOpacity(.6);
    // if (onedata.priority == 'Hot Lead') {
    //   _stripcolor = kdgreencolor;
    // }
    // if (onedata.priority == 'Medium Lead') {
    //   _stripcolor = kdyellowcolor;
    // }
    // if (onedata.priority == 'Cold Lead') {
    //   _stripcolor = Constants.kdred;
    // }

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MobileFullCallHistory(
                      mobile: onedata.mobile!,
                      name: onedata.fullName!,
                      leadid: onedata.leadId ?? '',
                      tableid: onedata.leadId!,
                      altmobile: onedata.altMobile,
                      callcontroller: callHistoryCtrl!,
                      loaction:
                          "${onedata.country} > ${onedata.state} > ${onedata.city}",
                      frompage: 'callhistory',
                    )));
      },
      child: Container(
        color: kdmediumlead,
        padding: const EdgeInsets.only(left: 10),
        margin: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    "${onedata.fullName}"
                        .text
                        .color(kdblackcolor)
                        .size(20)
                        .make(),
                    const Spacer(),
                    "${onedata.showdate}"
                        .text
                        .color(kdblackcolor)
                        .size(14)
                        .make(),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    "${onedata.response}"
                        .text
                        .color(kdblackcolor)
                        .size(14)
                        .make(),
                    const Spacer(),
                    "${onedata.showtime}"
                        .text
                        .color(kdblackcolor)
                        .size(14)
                        .make(),
                  ],
                ),
              ],
            )),
            IconButton(
                onPressed: () {
                  makemycall(
                    context: context,
                    frompagename: "MobileAppCallHistory",
                    lable: onedata.fullName ?? "",
                    leadid: onedata.leadId ?? '',
                    mobile: onedata.mobile ?? '',
                    altmobile: onedata.altMobile ?? '',
                  );
                },
                splashRadius: 10,
                icon: const Icon(
                  Icons.call,
                  color: kdblackcolor,
                  // size: 20,
                )),
          ],
        ),
      ),
    );
  }
}
