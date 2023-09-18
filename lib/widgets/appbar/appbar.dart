import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/various_keys.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'helper_widget.dart';

final Appbarcontroller _appbarcontroller = Get.find<Appbarcontroller>();
WorkPageController? workpagectrl;

class MyAppbar extends StatefulWidget {
  const MyAppbar({Key? key}) : super(key: key);

  @override
  _MyAppbarState createState() => _MyAppbarState();
}

String iconpath = "assets/icons/agcallerlogo.png";

class _MyAppbarState extends State<MyAppbar> {
  @override
  void initState() {
    workpagectrl = Get.find<WorkPageController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(color: kdfbblue),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: (!ResponsiveLayout.isComputer(context)),
            child: IconButton(
                onPressed: () {
                  // Scaffold.of(context).openDrawer();
                  ImportentKeys.initialpagekey.currentState!.openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Constants.kdwhitecolor,
                )),
          ),
          Expanded(
              child: Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CircleAvatar(
                      //   radius: 40,
                      //   backgroundColor:
                      //       Get.theme.colorScheme.secondaryVariant,
                      //   child: CircleAvatar(
                      //     backgroundColor: Colors.transparent,
                      //     radius: 40,
                      //     child: Image.asset(
                      //       iconpath,
                      //       height: 35,
                      //       fit: BoxFit.contain,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        width: 8,
                      ),
                      (_appbarcontroller.appbarheading.value)
                          .text
                          .color(kdwhitecolor)
                          .fontWeight(FontWeight.w600)
                          .size(40)
                          .make(),
                      const Spacer(),
                      Visibility(
                          visible: (_appbarcontroller.searchvisible.value &&
                              !(context.isMobile || context.isLargeTablet)),
                          child: const SerchInputWidget()),
                      Visibility(
                          visible: _appbarcontroller.addvisible.value,
                          child: const AddUserbutton()),
                      Visibility(
                          visible: _appbarcontroller.newleadvisible.value,
                          child: const AddLeadbutton()),
                      Visibility(
                          visible: _appbarcontroller.daterangevisible.value,
                          child: const DaterangepicWidget()),
                      Visibility(
                          visible: _appbarcontroller.downloadvisible.value,
                          child: const DownloadWidget()),
                      const AddCompBtn(),
                    ],
                  ))),
        ],
      ),
    );
  }
}
