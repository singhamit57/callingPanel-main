import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/pages/callhistory/callhistory_controller.dart';
import 'package:callingpanel/pages/leads/leadpage_controll.dart';
import 'package:callingpanel/pages/login/login_page.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/appbar/helper_widget.dart';
import 'package:callingpanel/widgets/drawer/drawer_control.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);
  final MyDrawerControll drawerControll = Get.find<MyDrawerControll>();
  final WorkPageController workpagectrl = Get.find<WorkPageController>();
  final LogeduserControll logeduserctrl = Get.find<LogeduserControll>();

  defaultwork({
    required String lable,
  }) {
    if (workpagectrl.workwidgetname.value == lable) return;
    workpagectrl.setworkpage(lable);
    Get.find<Appbarcontroller>().appbarheading.value = lable;
    drawerControll.selectedpage.value = lable;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Theme(
        data: Theme.of(context).copyWith(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.white),
            trackColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        child: Container(
          width: 220,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          color: kdwhitecolor,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.account_circle,
                  size: 75,
                ),
              ),
              const ProfileWid(),
              const Divider(
                height: 15,
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: null,
                child: Column(
                  children: [
                    buildcellside(
                        lable: PageSwitch.dashboard,
                        icon: Icons.home,
                        visible: true,
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.dashboard,
                          );
                          workpagectrl.onpageload();
                        }),
                    buildcellside(
                        lable: PageSwitch.companies,
                        icon: Icons.apartment,
                        visible: logeduserctrl.showcompoption.value,
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.companies,
                          );
                        }),
                    buildcellside(
                        lable: PageSwitch.admins,
                        icon: Icons.admin_panel_settings,
                        visible: logeduserctrl.showcompoption.value,
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.admins,
                          );
                        }),
                    buildcellside(
                        lable: PageSwitch.manager,
                        icon: Icons.engineering,
                        visible: !(logeduserctrl
                            .logeduserdetail.value.logeduserPost
                            .contains('Man')),
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.manager,
                          );
                        }),
                    buildcellside(
                        lable: PageSwitch.caller,
                        icon: Icons.contact_phone_rounded,
                        visible: true,
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.caller,
                          );
                        }),
                    buildcellside(
                        lable: PageSwitch.leads,
                        icon: Icons.connect_without_contact,
                        visible:
                            logeduserctrl.userpermissions.value.addEditLead,
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.leads,
                          );
                          Get.find<LeadPageCtrl>().openbysidebar();
                        }),
                    buildcellside(
                        lable: PageSwitch.callhistory,
                        icon: Icons.history,
                        visible:
                            logeduserctrl.userpermissions.value.viewReports,
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.callhistory,
                          );
                          Get.find<CallHistoryWebCtrl>().openbysidebar();
                        }),
                    buildcellside(
                        lable: PageSwitch.reports,
                        icon: Icons.auto_stories,
                        visible:
                            logeduserctrl.userpermissions.value.viewReports,
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.reports,
                          );
                        }),
                    buildcellside(
                        lable: PageSwitch.configuration,
                        icon: Icons.settings_suggest,
                        visible: (logeduserctrl
                                .userpermissions.value.addEditDepartmetn ||
                            logeduserctrl
                                .userpermissions.value.addEditResponse),
                        ontap: () {
                          defaultwork(
                            lable: PageSwitch.configuration,
                          );
                        }),
                    buildcellside(
                        lable: PageSwitch.logout,
                        icon: Icons.logout,
                        visible: true,
                        ontap: () {
                          Get.offAll(const LoginPage(),
                              transition: Transition.leftToRight,
                              duration: const Duration(milliseconds: 1200));
                        }),
                  ],
                ),
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildcellside({
    required String lable,
    required IconData icon,
    required Function() ontap,
    required bool visible,
  }) {
    return Obx(() => Visibility(
          visible: visible,
          child: Column(
            children: [
              Container(
                decoration: drawerControll.selectedpage.value == lable
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            kdfbblue.withOpacity(0.9),
                            kdfbblue.withOpacity(0.5),
                          ],
                        ),
                      )
                    : null,
                child: ListTile(
                  title: Text(
                    lable,
                    style: TextStyle(
                        color: drawerControll.selectedpage.value == lable
                            ? kdwhitecolor
                            : kdblackcolor,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(Constants.kdPadding),
                    child: Icon(
                      icon,
                      color: drawerControll.selectedpage.value == lable
                          ? kdwhitecolor
                          : kdblackcolor,
                    ),
                  ),
                  onTap: ontap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Divider(
                color: Get.theme.colorScheme.secondary,
                thickness: 0.1,
              ),
            ],
          ),
        ));
  }
}


/*


                  if (buttonNames[index].title == 'LogOut') {
                    Get.find<LoginPageCtrl>().buttonstate.value =
                        ButtonState.idle;
                    Get.offAll(LoginPage(),
                        transition: Transition.leftToRight,
                        duration: Duration(milliseconds: 1200));
                  } else {
                    if (buttonNames[index].title == PageSwitch.leads) {
                      Get.find<LeadPageCtrl>().openbysidebar();
                    }

                    drawerControll.selectedtab.value = index;
                    workpagectrl.setworkpage(buttonNames[index].title);
                    Get.find<Appbarcontroller>().appbarheading.value =
                        buttonNames[index].title;
                  }
                
*/