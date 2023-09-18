import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/extensions/widget_ext.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mini_widgets.dart/nodatafound_lottie.dart';
import 'package:callingpanel/mini_widgets.dart/searchingdata_lottie.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'leadpage_controll.dart';
import 'leadpagecard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({Key? key}) : super(key: key);

  @override
  _LeadsPageState createState() => _LeadsPageState();
}

LeadPageCtrl? leadPageCtrl;
LogeduserControll? logeduserControll;
Appbarcontroller? appbarcontroller;
ScrollController? listscrollcrtl;
RefreshController refreshController = RefreshController(initialRefresh: false);
var isrequested = false.obs;

class _LeadsPageState extends State<LeadsPage> {
  var selectionEnabled = false.obs;
  var selectAll = false.obs;
  var selectedTiels = <int>[].obs;
  final _scrlCtrl = ScrollController();

  @override
  void dispose() {
    leadPageCtrl!.leaddetailList.clear();
    leadPageCtrl!.allleaddetailList.clear();
    leadPageCtrl!.totalavailpage = 0;
    leadPageCtrl!.nexpagenumber = 0;
    leadPageCtrl!.totalavaildata = 0;
    leadPageCtrl!.previousbody = {};
    leadPageCtrl!.pagetitel.value = 'Leads';
    leadPageCtrl!.filtercategory = '';
    listscrollcrtl!.dispose();
    // leadPageCtrl!.prefillterdata = null;
    appbarcontroller!.newleadvisible.value = false;
    appbarcontroller!.searchvisible.value = false;
    appbarcontroller!.daterangevisible.value = false;
    appbarcontroller!.downloadvisible.value = false;
    appbarcontroller!.downloadTip.value = '';
    super.dispose();
  }

  @override
  void initState() {
    leadPageCtrl = Get.find<LeadPageCtrl>();
    logeduserControll = Get.find<LogeduserControll>();
    appbarcontroller = Get.find<Appbarcontroller>();
    isrequested.value = false;
    listscrollcrtl = ScrollController();
    listscrollcrtl!.addListener(() {
      scrollListener();
    });
    if (!leadPageCtrl!.isloadingdata.value) {
      // leadPageCtrl!.getleadlist();
      leadPageCtrl!.pagetitel.value = 'Leads';
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appbarcontroller!.newleadvisible.value = true;
      appbarcontroller!.searchvisible.value = true;
      appbarcontroller!.daterangevisible.value = true;
      appbarcontroller!.downloadvisible.value = true;
      appbarcontroller!.downloadTip.value = 'Download this record.';
      // leadPageCtrl!.getleadlist(pagenumber: 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Visibility(
                    visible: (leadPageCtrl!.isloadingdata.value),
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
                            child: (leadPageCtrl!.pagetitel.value)
                                .text
                                .xl4
                                .color(Get.theme.colorScheme.onSecondary)
                                .fontFamily('PoppinsSemiBold')
                                .make())),
                    Visibility(
                      visible: (leadPageCtrl!.leaddetailList.isNotEmpty &&
                          !isrequested.value),
                      child:
                          ("${leadPageCtrl!.leaddetailList.length} Out Of ${leadPageCtrl!.totalavaildata}")
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
                              Get.theme.colorScheme.onSecondary.withOpacity(.5))
                          .size(14)
                          .make(),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                10.heightBox,
                Visibility(
                  visible: (!leadPageCtrl!.isloadingdata.value &&
                      leadPageCtrl!.leaddetailList.isNotEmpty),
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: selectionEnabled.value,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            20.widthBox,
                            Checkbox(
                              value: selectAll.value,
                              onChanged: (value) {
                                selectAll.value = value ?? false;
                                if (value ?? false) {
                                } else {}
                              },
                              checkColor: kdwhitecolor,
                              fillColor: MaterialStateProperty.resolveWith(
                                  (states) => kdfbblue),
                            ),
                            "Select All".text.black.size(16).make(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Visibility(
                        visible: selectionEnabled.value,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                bool _confirm = await makeconfirmation(
                                    context: context,
                                    titel: "Confirmation",
                                    content:
                                        "Do you wan to delete ${selectAll.value ? leadPageCtrl!.totalavaildata : selectedTiels.length} leads ?",
                                    yestobutton: false);
                                if (!_confirm) return;
                                await leadPageCtrl!.deleteMultiplelead(
                                  isallselected: selectAll.value,
                                  indexes: selectedTiels,
                                );

                                selectionEnabled.value = false;
                              },
                              child: "Delete"
                                  .text
                                  .color(Constants.kdred)
                                  .size(16)
                                  .fontWeight(FontWeight.w600)
                                  .make(),
                            ),
                            20.widthBox,
                            InkWell(
                              onTap: () {
                                selectionEnabled.value = false;
                                selectedTiels.clear();
                              },
                              child: "Cancle"
                                  .text
                                  .color(kdfbblue)
                                  .size(16)
                                  .fontWeight(FontWeight.w600)
                                  .make(),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !selectionEnabled.value,
                        child: InkWell(
                          onTap: () {
                            selectionEnabled.value = true;
                          },
                          child: "Select Multiple"
                              .text
                              .color(kdfbblue)
                              .size(16)
                              .fontWeight(FontWeight.w600)
                              .make(),
                        ),
                      ),
                      10.widthBox,
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              controller: listscrollcrtl,
              child: Column(
                children: [
                  Visibility(
                      visible: (leadPageCtrl!.leaddetailList.isEmpty &&
                          leadPageCtrl!.isloadingdata.value),
                      child: buildsearchingdatalottie()),
                  Visibility(
                    visible: (leadPageCtrl!.leaddetailList.isEmpty &&
                        leadPageCtrl!.isloadingdata.value == false),
                    child: buildnodatlottie(),
                  ),
                  Visibility(
                      visible: leadPageCtrl!.leaddetailList.isNotEmpty,
                      child: Scrollbar(
                        controller: _scrlCtrl,
                        child: ListView.builder(
                            shrinkWrap: true,
                            controller: _scrlCtrl,
                            itemCount: leadPageCtrl!.leaddetailList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return BuildLeadOneCardWeb(
                                onedata: leadPageCtrl!.leaddetailList[index],
                                logeduserControll: logeduserControll!,
                                ischeckenabled: selectionEnabled.value,
                                onselect: (value) {
                                  // print(value);
                                  if (value ?? false) {
                                    selectedTiels.add(index);
                                    if (selectedTiels.length ==
                                        leadPageCtrl!.totalavaildata) {
                                      selectAll.value = true;
                                    }
                                  } else {
                                    selectedTiels.remove(index);
                                    if (selectAll.value) {
                                      selectAll.value = false;
                                    }
                                  }
                                  setState(() {});
                                },
                                ischecked: (selectedTiels.contains(index) ||
                                    selectAll.value),
                              );
                            }),
                      )).custumScrollBehaviour,
                  Visibility(
                      visible: (isrequested.value), child: buildLinerloading()),
                ],
              ),
            ))
          ],
        ));
  }
}

void handelScrollWithIndex(int index, var pagestate) {
  final itempostion = index + 1;

  final requestmoredata = itempostion % 20 == 0 && itempostion != 0;
  final pagetorequest = itempostion ~/ 20;
  if (requestmoredata && pagetorequest + 1 >= 5) {}
}

scrollListener() async {
  // print(listscrollcrtl.offset);
  // print(listscrollcrtl.position.maxScrollExtent);
  // print(listscrollcrtl.position.outOfRange);
  double maxscroll = listscrollcrtl!.position.maxScrollExtent;
  double currentscroll = listscrollcrtl!.offset;
  if (currentscroll >= maxscroll * .98 &&
      leadPageCtrl!.totalavailpage >= (leadPageCtrl!.nexpagenumber + 1)) {
    if (leadPageCtrl!.leaddetailList.isNotEmpty && !isrequested.value) {
      isrequested.value = true;
      await leadPageCtrl!.getleadlist(
        pagenumber: leadPageCtrl!.nexpagenumber,
      );
      isrequested.value = false;
    }
  }
}
