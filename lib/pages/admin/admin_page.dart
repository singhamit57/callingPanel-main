import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/extensions/widget_ext.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/mini_widgets.dart/editdelete_widget.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mini_widgets.dart/nodatafound_lottie.dart';
import 'package:callingpanel/mini_widgets.dart/onlineuser_widget.dart';
import 'package:callingpanel/models/manager/addedituser_model.dart';
import 'package:callingpanel/pages/adduser/adduser_controller.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'admin_controller.dart';

AdminPageWebCtrl? admincontroll;
AddEditUserController? userctrl;
LogeduserControll? logeduserControll;

class AdminWebPage extends StatefulWidget {
  const AdminWebPage({Key? key}) : super(key: key);

  @override
  _AdminWebPageState createState() => _AdminWebPageState();
}

class _AdminWebPageState extends State<AdminWebPage> {
  final ScrollController _ctrl = ScrollController();
  final _appbarCtrl = Get.find<Appbarcontroller>();

  @override
  void initState() {
    admincontroll = Get.find<AdminPageWebCtrl>();
    userctrl = Get.find<AddEditUserController>();
    logeduserControll = Get.find<LogeduserControll>();
    _appbarCtrl.hidealloption();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      admincontroll!.adminsList.value = admincontroll!.alladminsList;
      _appbarCtrl.addvisible.value = true;
      _appbarCtrl.searchvisible.value = true;
    });
    // admincontroll!.getrecords();
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
                  visible: admincontroll!.issearching.value,
                  child: buildLinerloading()),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 25),
                  child: "Admins"
                      .text
                      .xl4
                      .color(Get.theme.colorScheme.onSecondary)
                      .fontFamily('PoppinsSemiBold')
                      .make()),
              Visibility(
                visible: (admincontroll!.adminsList.isEmpty &&
                    admincontroll!.issearching.value == false),
                child: buildnodatlottie(),
              ),
              Visibility(
                visible: admincontroll!.adminsList.isNotEmpty,
                child: Scrollbar(
                  controller: _ctrl,
                  child: ListView.builder(
                      itemCount: admincontroll!.adminsList.length,
                      controller: _ctrl,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => buildadmincard(
                          context: context,
                          index: index,
                          onedata: admincontroll!.adminsList[index])),
                ),
              ).custumScrollBehaviour,
            ],
          )),
    );
  }

  Widget buildadmincard({
    required context,
    required int index,
    required NewUserModel onedata,
  }) {
    bool isonline = false;
    String lastlogin = 'Offline';
    int position = logeduserControll!.onlineUsersList
        .indexWhere((element) => element.userId == onedata.userId);
    if (position >= 0) {
      isonline = logeduserControll!.onlineUsersList[position].isonlie;
      lastlogin = logeduserControll!.onlineUsersList[position].lastLogin;
    }
    String gendername = onedata.gender;
    IconData gendericon = Icons.transgender;
    if (gendername == 'Female') {
      gendericon = Icons.female;
    } else if (gendername == 'Male') {
      gendericon = Icons.male;
    }

    return Card(
      elevation: 5,
      color: kdbluecolor,
      child: ExpansionTile(
        collapsedIconColor: Get.theme.colorScheme.onSecondary,
        tilePadding: const EdgeInsets.only(left: 30, right: 20),
        title: Row(
          children: [
            buildtelibodytext(
              size: 24,
              value: '${onedata.fullName} (${onedata.companyName})',
              icon: Icons.person,
            ),
            const Spacer(),
            buildOnlineCircle(isonline: isonline),
          ],
        ),
        subtitle: Row(
          children: [
            buildtelibodytext(
              value: onedata.userId,
              icon: Icons.badge,
              size: 14,
            ),
            const Spacer(),
            buildLastLogin(isonline: isonline, lastlogin: lastlogin),
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
                  flex: 3,
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
                        buildtelibodytext(value: gendername, icon: gendericon),
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
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildteliheadtext(
                            value: 'Add/Edit Department', allowed: true),
                        buildteliheadtext(
                            value: 'Add/Edit Response', allowed: true),
                        buildteliheadtext(
                            value: 'Add/Edit Users', allowed: true),
                        buildteliheadtext(
                            value: 'Add/Edit Leads', allowed: true),
                        buildteliheadtext(value: 'View Reports', allowed: true),
                        buildteliheadtext(
                            value: 'Update Reports', allowed: true),
                      ],
                    ),
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
                                value: 'Make Call', allowed: true),
                            buildteliheadtext(value: 'Send SMS', allowed: true),
                            buildteliheadtext(
                                value: 'Send Mail', allowed: true),
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
                            content: 'Do you want to delete this telecaller ?',
                            yestobutton: false,
                          );
                          if (result == true) {
                            admincontroll!.deleteuserdata(
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
    );
  }
}

Widget buildteliheadtext({
  required String value,
  required bool allowed,
  double? size,
}) {
  return value
      .text
      // .color(allowed ? kdgreencolor : Constants.kdred)
      .white
      .size(size ?? 18)
      .align(TextAlign.left)
      .letterSpacing(1.8)
      .make();
}

Widget buildtelibodytext({
  required String value,
  required IconData icon,
  double? size,
}) {
  return Row(
    children: [
      Icon(
        icon,
        // color: kdskyblue,
        size: 20,
      ),
      const SizedBox(
        width: 20,
      ),
      value.text.color(kdwhitecolor).size(size ?? 16).letterSpacing(1.8).make()
    ],
  );
}
