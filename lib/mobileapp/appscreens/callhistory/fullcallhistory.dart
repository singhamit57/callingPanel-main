import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/make_call.dart';
import 'package:callingpanel/functions/whatsp_send.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mobileapp/appscreens/callhistory/callhistory_controll.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/outgoingcallview/outgoingcallview_controller.dart';
import 'package:callingpanel/mobileapp/appscreens/newdatapage/newdata_controll.dart';
import 'package:callingpanel/mobileapp/appscreens/newdatapage/newdata_page.dart';
import 'package:callingpanel/mobileapp/mobilewidgets/callresponsepage.dart/callresponse_page.dart';
import 'package:callingpanel/models/leads/leadfulldetail_model.dart';
import 'package:callingpanel/models/oneleadhistory_model.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'callhistory_card.dart';

var callloglist = <OneLeadCallLog>[].obs;
var issearching = false.obs;
LogeduserControll? logeduserctrl;
LeadFullDetail leaddetails = LeadFullDetail();

class MobileFullCallHistory extends StatefulWidget {
  final String? herotag;
  final String tableid;
  final String name;
  final String mobile;
  final String leadid;
  final String? altmobile;
  final String? loaction;
  final CallHistoryCtrl? callcontroller;
  final MobileNewDataCtrl? newDataCtrl;
  final String frompage;
  const MobileFullCallHistory({
    Key? key,
    this.herotag,
    required this.tableid,
    required this.name,
    required this.mobile,
    required this.leadid,
    this.altmobile,
    this.callcontroller,
    this.newDataCtrl,
    required this.frompage,
    this.loaction,
  }) : super(key: key);

  @override
  _MobileFullCallHistoryState createState() => _MobileFullCallHistoryState();
}

class _MobileFullCallHistoryState extends State<MobileFullCallHistory> {
  getcalllog() async {
    String _url = mainurl + '/leadresponse/oneleadcallhistory_app.php';
    var _body = {
      'CompID': logeduserctrl!.logeduserdetail.value.compId,
      'UserID': logeduserctrl!.logeduserdetail.value.logeduserId,
      'TableId': widget.tableid,
      'Mobile': widget.mobile,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    issearching.value = true;
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(_body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          callloglist.value = List<OneLeadCallLog>.from(
              data['ResultData'].map((x) => OneLeadCallLog.fromJson(x)));
          issearching.value = false;
        } else {
          issearching.value = false;
        }
      }
    } catch (e) {
      debugPrint('getcalllog :$e');
      issearching.value = false;
    }
  }

  initialsetup() {
    leaddetails.tableId = widget.tableid;
    leaddetails.fullName = widget.name;
    leaddetails.mobile = widget.mobile;
  }

  @override
  void initState() {
    logeduserctrl = Get.find<LogeduserControll>();
    getcalllog();
    initialsetup();
    super.initState();
  }

  @override
  void dispose() {
    callloglist.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            // backgroundColor: Get.theme.primaryColorDark,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  // color: kdwhitecolor,
                )),
          ),
          preferredSize: Size(Get.width, 50),
        ),
        body: Hero(
          tag: widget.herotag ?? 'fullcallhistory',
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Image.asset(
                        'assets/icons/agcallerlogo.png',
                        height: 85,
                        fit: BoxFit.contain,
                      ),
                      radius: 50,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.name.text
                    .color(Get.theme.colorScheme.primary)
                    .fontFamily('PoppinsSemiBold')
                    .size(18)
                    .makeCentered(),
                widget.mobile.text
                    .color(Get.theme.colorScheme.primary)
                    .fontFamily('PoppinsSemiBold')
                    .size(16)
                    .makeCentered(),
                if (widget.altmobile != null && widget.altmobile!.length >= 4)
                  widget.altmobile!.text.white.size(18).makeCentered(),
                Visibility(
                  visible: widget.loaction != null,
                  child: (widget.loaction ?? "")
                      .text
                      .color(Get.theme.colorScheme.primary)
                      .fontFamily('PoppinsSemiBold')
                      .size(16)
                      .makeCentered(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildoptionavatar(
                      icon: Icons.call,
                      lable: "Call",
                      textcolor: Get.theme.colorScheme.onBackground,
                      onTap: () {
                        final callctrl = Get.find<OutgoincallviewCtrl>();
                        callctrl.addinalinfo.clear();
                        callctrl.addinalinfo = [
                          widget.frompage,
                          widget.mobile,
                          widget.tableid,
                          widget.leadid,
                          widget.name,
                        ];
                        makemycall(
                            context: context,
                            lable: widget.name,
                            frompagename: "MobileFullCallHistory",
                            leadid: widget.leadid,
                            mobile: widget.mobile,
                            altmobile: widget.altmobile);
                      },
                    ),
                    buildoptionavatar(
                      // icon: Icons.chat,
                      leadwidget: Image.asset(
                        'assets/icons/whatsappblack.png',
                        height: 30,
                        width: 30,
                        fit: BoxFit.contain,
                      ),
                      lable: "Whatsapp",
                      textcolor: Get.theme.colorScheme.onBackground,
                      onTap: () {
                        mobilenumberselection(
                            context: context,
                            mobile: widget.mobile,
                            altmobile: widget.altmobile ?? '');
                      },
                    ),
                    buildoptionavatar(
                      icon: Icons.edit,
                      lable: "Response",
                      textcolor: Get.theme.colorScheme.onBackground,
                      onTap: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MobileCallResponsePage(
                                      leaddata: leaddetails,
                                      havedata: true,
                                      datatype: 'callhistory',
                                    )));
                        if (result == true) {
                          if (widget.frompage == 'newdata') {
                            newDataCtrl!.getfollowlist();
                          }
                          if (widget.frompage == 'callhistory') {
                            widget.callcontroller!.getreponsehistry();
                          }

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Get.theme.colorScheme.onSecondary,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    children: [
                      "Call Log"
                          .text
                          .color(Get.theme.colorScheme.onBackground)
                          .fontFamily('PoppinsSemiBold')
                          .size(14)
                          .make(),
                    ],
                  ),
                ),
                Obx(() => Column(
                      children: [
                        Visibility(
                            visible: issearching.value,
                            child: buildLinerloading()),
                        ListView.builder(
                            itemCount: callloglist.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // return Container(
                              //   padding: const EdgeInsets.only(bottom: .5),
                              //   // color: kdwhitecolor,
                              //   child: ondedetailcard(
                              //       context: context,
                              //       onedata: callloglist[index]),
                              // );

                              return CallHistoryCard(
                                onedata: callloglist[index],
                                index: index,
                                totalcards: callloglist.length,
                              );
                            })
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildoptionavatar({
    IconData? icon,
    Widget? leadwidget,
    Color? textcolor,
    required String lable,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: kdwhitecolor,
            radius: 24,
            child: icon != null
                ? Icon(
                    icon,
                    color: Get.theme.colorScheme.onBackground,
                    size: 25,
                  )
                : leadwidget,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: (lable)
                .text
                .color(textcolor ?? Get.theme.colorScheme.primary)
                .size(14)
                .makeCentered(),
          ),
        ],
      ),
    );
  }

  Widget ondedetailcard({
    required context,
    required OneLeadCallLog onedata,
  }) {
    return Card(
      elevation: 5,
      color: snow,
      shadowColor: Get.theme.colorScheme.primary,
      child: ExpansionTile(
        collapsedIconColor: Get.theme.colorScheme.onSecondary,
        title: "${onedata.response} (${onedata.department})"
            .text
            .color(Get.theme.colorScheme.primary)
            .fontFamily('PoppinsSemiBold')
            .overflow(TextOverflow.ellipsis)
            .size(12)
            .maxLines(2)
            .softWrap(true)
            .make(),
        subtitle: (onedata.remark ?? 'No remark')
            .text
            .color(Get.theme.colorScheme.primary)
            .fontFamily('PoppinsSemiBold')
            .size(10)
            .maxLines(2)
            .softWrap(true)
            .make(),
        trailing:
            "${onedata.showdate} ${onedata.showtime} \n ${onedata.showduration}"
                .text
                .color(Get.theme.colorScheme.onSecondary)
                .fontFamily('PoppinsSemiBold')
                .size(10)
                .align(TextAlign.right)
                .make(),
      ),
    );
  }
}

/*
ListTile(
        title: "Not Connected".text.white.size(12).bold.make(),
        subtitle:
            "Not conect to cutomer lsdf sdafl sadflsadf lsadf sadfl asdfldsaf asldfdsaf"
                .text
                .color(kdwhitecolor.withOpacity(.7))
                .size(10)
                .softWrap(true)
                .make(),
        trailing: "12/07/2020 12:00 PM \n 40 s"
            .text
            .color(Constants.kdorange.withOpacity(.7))
            .size(10)
            .align(TextAlign.right)
            .make(),
      ),
*/

/*
[{
  "department":"department",
  "response":"response",
  "intdate":"intdate",
  "priority":"priority",
  "leadresult":"department",
  "remark":"department",
  "callduration":"department",
  "updateby":"department",
  "showdate":"department",
  "showtime":"department",
  "showduration":"department",
  
}]
*/