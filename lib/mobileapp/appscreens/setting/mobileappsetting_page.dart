import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/changepassword/changepassword_page.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/leaddepartment/changeleaddepart_page.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/leadlocation/leadlocationchange_page.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/messagetemplate/pretemplate_page.dart';
import 'package:callingpanel/mobileapp/appscreens/newdatapage/newdata_controll.dart';
import 'package:callingpanel/models/leads/leadfulldetail_model.dart';
import 'package:callingpanel/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

class MobileSettingsPage extends StatelessWidget {
  const MobileSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgrounsColor,
      appBar: AppBar(
        // centerTitle: true,
        title: "Settings".text.color(kdwhitecolor).xl2.bold.make(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildonerow(
                icon: Icons.security,
                lable: "Change password",
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordMobile()));
                }),
            buildonerow(
                icon: Icons.engineering,
                lable: "Lead Department",
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LeadDepartsMobile()));
                }),
            buildonerow(
                icon: Icons.place,
                lable: "Lead Location",
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LeadLocationsMobile()));
                }),
            buildonerow(
                icon: Icons.chat,
                lable: "Message Templates",
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PreMessageTemplate()));
                }),
            buildonerow(
                icon: Icons.logout,
                lable: "Logout",
                ontap: () {
                  Get.find<MobileNewDataCtrl>().shownewdta.value =
                      LeadFullDetail();
                  Get.off(const LoginPage(),
                      transition: Transition.leftToRight,
                      duration: const Duration(milliseconds: 1200));
                }),
          ],
        ),
      ),
    );
  }

  Widget buildonerow({
    required IconData icon,
    Widget? leading,
    required String lable,
    required Function ontap,
  }) {
    return InkWell(
      onTap: () => ontap(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1,
          color: Get.theme.colorScheme.primary.withOpacity(.1),
        ))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: leading ??
                  Icon(
                    icon,
                    // color: kdwhitecolor,
                    size: 22,
                  ),
            ),
            Expanded(
                child: lable.text.heightLoose
                    .color(Get.theme.colorScheme.primary)
                    .size(16)
                    .make())
          ],
        ),
      ),
    );
  }
}
