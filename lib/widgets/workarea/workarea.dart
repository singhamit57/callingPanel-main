import 'package:callingpanel/pages/adduser/addremove_user.dart';
import 'package:callingpanel/pages/dashboard/dashboardpages/dashboard_page1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'workarea_controller.dart';

class Workarea extends StatefulWidget {
  const Workarea({Key? key}) : super(key: key);

  @override
  _WorkareaState createState() => _WorkareaState();
}

class _WorkareaState extends State<Workarea> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          int index = 0;
          String pagename = Get.find<WorkPageController>().workwidgetname.value;
          int _ind = stackpagelist
              .indexWhere((element) => element.pagename == pagename);

          return IndexedStack(
            index: _ind >= 0 ? _ind : index,
            children: stackpagelist.map((e) {
              return e.widget;
            }).toList(),
          );
        }),
      ],
    );
  }
}

List<StackPageModel> stackpagelist = [
  StackPageModel(
    pagename: 'Dashboard',
    widget: const DashBoardCharts(),
    visible: true,
  ),
  StackPageModel(
    pagename: 'AddEditUser',
    widget: const AddRemoveUsersPage(),
    visible: true,
  ),
  StackPageModel(
    pagename: 'Super Admin',
    widget: ("Super Admin").text.make(),
    visible: true,
  ),
  StackPageModel(
    pagename: 'Admin',
    widget: const DashBoardCharts(),
    visible: true,
  ),
  StackPageModel(
    pagename: 'Manager',
    widget: const DashBoardCharts(),
    visible: true,
  ),
  StackPageModel(
    pagename: 'Telecaller',
    widget: const DashBoardCharts(),
    visible: true,
  ),
  StackPageModel(
    pagename: 'Reports',
    widget: const DashBoardCharts(),
    visible: true,
  ),
  StackPageModel(
    pagename: 'Configuration',
    widget: const DashBoardCharts(),
    visible: true,
  ),
];

class StackPageModel {
  String pagename;
  Widget widget;
  bool? visible;
  StackPageModel(
      {required this.pagename, required this.widget, this.visible = true});
}
