import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/extensions/widget_ext.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/mini_widgets.dart/editdelete_widget.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mini_widgets.dart/onlineuser_widget.dart';
import 'package:callingpanel/models/manager/addedituser_model.dart';
import 'package:callingpanel/pages/adduser/adduser_controller.dart';
import 'package:callingpanel/pages/manager/mager_controller.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

MangerListCtrl? mangerListCtrl;
WorkPageController? workPageController;
LogeduserControll? logeduserControll;

class ManagerListPage extends StatefulWidget {
  const ManagerListPage({Key? key}) : super(key: key);

  @override
  _ManagerListPageState createState() => _ManagerListPageState();
}

class _ManagerListPageState extends State<ManagerListPage> {
  final _sctCtrl = ScrollController();
  @override
  void initState() {
    mangerListCtrl = Get.find<MangerListCtrl>();
    workPageController = Get.find<WorkPageController>();
    logeduserControll = Get.find<LogeduserControll>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.find<Appbarcontroller>().addvisible.value = true;
      Get.find<Appbarcontroller>().searchvisible.value = true;
      mangerListCtrl!.managerslist.value = mangerListCtrl!.allmanagerslist;
    });
    // mangerListCtrl!.getrecords();
    super.initState();
  }

  @override
  void dispose() {
    Get.find<Appbarcontroller>().addvisible.value = false;
    Get.find<Appbarcontroller>().searchvisible.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: mangerListCtrl!.issearching.value,
                  child: buildLinerloading()),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 25),
                  child: "Managers"
                      .text
                      .xl4
                      .color(Get.theme.colorScheme.onSecondary)
                      .fontFamily('PoppinsSemiBold')
                      .make()),
              Visibility(
                visible: (mangerListCtrl!.managerslist.isEmpty &&
                    mangerListCtrl!.issearching.value == false),
                child: Container(
                  height: Get.height - 300,
                  width: Get.width,
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    'assets/blue-search-not-found.json',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Visibility(
                visible: mangerListCtrl!.managerslist.isNotEmpty,
                child: Scrollbar(
                  controller: _sctCtrl,
                  child: ListView.builder(
                      itemCount: mangerListCtrl!.managerslist.length,
                      controller: _sctCtrl,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => buildmanagercard(
                          context: context,
                          index: index,
                          onedata: mangerListCtrl!.managerslist[index])),
                ),
              ).custumScrollBehaviour,
            ],
          )),
    );
  }

  Widget buildmanagercard({
    required context,
    required int index,
    required NewUserModel onedata,
  }) {
    String gendername = onedata.gender;
    IconData gendericon = Icons.transgender;
    bool isonline = false;
    String lastlogin = 'Offline';
    int position = logeduserControll!.onlineUsersList
        .indexWhere((element) => element.userId == onedata.userId);
    if (position >= 0) {
      isonline = logeduserControll!.onlineUsersList[position].isonlie;
      lastlogin = logeduserControll!.onlineUsersList[position].lastLogin;
    }

    if (gendername == 'Female') {
      gendericon = Icons.female;
    } else if (gendername == 'Male') {
      gendericon = Icons.male;
    }
    return InkWell(
      onDoubleTap: () {
        workPageController!.callerfulldetailopen(
            compid: onedata.companyId, userid: onedata.userId);
      },
      child: Card(
        elevation: 10,
        color: kdfbblue,
        child: ExpansionTile(
          backgroundColor: kdfbblue,
          collapsedIconColor: Get.theme.colorScheme.onSecondary,
          title: Row(
            children: [
              buildtelibodytext(
                  value: '${onedata.fullName} (${onedata.department})',
                  icon: Icons.person,
                  txtsize: 20),
              const Spacer(),
              buildOnlineCircle(isonline: isonline),
            ],
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  buildtelibodytext(value: onedata.userId, icon: Icons.badge),
                  const Spacer(),
                  buildLastLogin(isonline: isonline, lastlogin: lastlogin),
                ],
              ),
              Visibility(
                visible: Get.find<LogeduserControll>().showcompoption.value,
                child: buildtelibodytext(
                    value: '${onedata.companyName} (${onedata.companyId})',
                    icon: Icons.apartment),
              ),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              // height: 140,
              constraints: const BoxConstraints(maxHeight: 200),
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Row(
                children: [
                  ///Column 1
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildtelibodytext(
                              value: '${onedata.mobile} ,${onedata.altMobile}',
                              icon: Icons.phone),
                          buildtelibodytext(
                              value: onedata.email, icon: Icons.email),
                          buildtelibodytext(
                              value:
                                  '${onedata.country} > ${onedata.state} > ${onedata.city}',
                              icon: Icons.place),
                          buildtelibodytext(
                              value: onedata.password, icon: Icons.security),
                          buildtelibodytext(
                              value: gendername, icon: gendericon),
                          buildtelibodytext(
                              value: '${onedata.bankName} (${onedata.ifsc})',
                              icon: Icons.account_balance),
                          buildtelibodytext(
                              value: onedata.accountNumber,
                              icon: Icons.account_balance_wallet),
                        ],
                      ),
                    ),
                  ),

                  ///column 2
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildteliheadtext(
                            value: 'Add/Edit Department',
                            allowed: onedata.addEditDepartmetn == '1'),
                        buildteliheadtext(
                            value: 'Add/Edit Response',
                            allowed: onedata.addEditResponse == '1'),
                        buildteliheadtext(
                            value: 'Add/Edit Users',
                            allowed: onedata.addEditUser == '1'),
                        buildteliheadtext(
                            value: 'Add/Edit Leads',
                            allowed: onedata.addEditLead == '1'),
                        buildteliheadtext(
                            value: 'View Reports',
                            allowed: onedata.viewReports == '1'),
                        buildteliheadtext(
                            value: 'Update Reports',
                            allowed: onedata.updateReport == '1'),
                      ],
                    ),
                  ),

                  ///Column3
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 15),
                          child: Column(
                            children: [
                              buildteliheadtext(
                                  value: 'Make Call',
                                  allowed: onedata.makeCall == '1'),
                              buildteliheadtext(
                                  value: 'Send SMS',
                                  allowed: onedata.sendSms == '1'),
                              buildteliheadtext(
                                  value: 'Send Mail',
                                  allowed: onedata.sendMail == '1'),
                              buildteliheadtext(
                                  value: onedata.userstatus,
                                  allowed: onedata.userstatus == 'Active'),
                            ],
                          ),
                        ),
                        const Spacer(),
                        buildeditdeletebtn(
                          context: context,
                          ondedit: () {
                            Get.find<AddEditUserController>()
                                .edituser(edituser: onedata);
                            Get.find<WorkPageController>()
                                .setworkpage(PageSwitch.addedituser);
                          },
                          ondelete: () async {
                            var result = await makeconfirmation(
                              context: context,
                              titel: 'Confirmation',
                              content: 'Do you want to delete this manager ?',
                              yestobutton: false,
                            );
                            if (result == true) {
                              mangerListCtrl!.deleteuserdata(
                                  tableid: onedata.preTableId.toString(),
                                  deleteuserid: onedata.userId.toString());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildteliheadtext({
  required String value,
  required bool allowed,
}) {
  return value
      .text
      // .color(allowed ? kdgreencolor : Constants.kdred)
      .white
      .size(18)
      .align(TextAlign.left)
      .letterSpacing(1.8)
      .make();

  // return Text(value,style: TextStyle(color:allowed ? kdskyblue : Constants.kdred,fontSize: 18,fo ),);
}

Widget buildtelibodytext(
    {required String value, required IconData icon, double? txtsize}) {
  return Row(
    children: [
      Icon(
        icon,
        // color: kdskyblue,
        size: 20,
      ),
      const SizedBox(
        width: 15,
      ),
      value.text
          .color(kdwhitecolor)
          .size(txtsize ?? 16)
          .letterSpacing(1.8)
          .make()
    ],
  );
}

// class _MobileManagerCard extends StatelessWidget {
//   final int index;
//   final NewUserModel onedata;
//   const _MobileManagerCard(
//       {Key? key, required this.index, required this.onedata})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: kdwhitecolor,
//       child: Column(
//         children: [
//           OneVertLableContent(
//             lable: "Name",
//             content: onedata.fullName,
//           ),
//         ],
//       ),
//     );
//   }
// }
