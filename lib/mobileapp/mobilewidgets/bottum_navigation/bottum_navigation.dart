// ignore_for_file: unrelated_type_equality_checks

import 'package:callingpanel/constants/const_colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'buttomnavigation_controll.dart';

Widget buttomnavigation({required ButtomNavigationCtrl controll}) {
  return Obx(() {
    Color _back = controll.selectedtab == 0
        ? Constants.kdorange
        : Get.theme.primaryColorDark;
    return CurvedNavigationBar(
      height: 50,
      index: controll.selectedtab.value,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: _back,
      // animationCurve: Curve.v,
      // color: Get.theme.primaryColorDark,
      items: const [
        Icon(Icons.add_ic_call, size: 20),
        Icon(Icons.compare_arrows, size: 20),
        Icon(Icons.person, size: 20),
        Icon(Icons.settings, size: 20),
      ],
      onTap: (index) {
        controll.selectedtab.value = index;
        // endlastcall();
        //Handle button tap
      },
    );
  });
}
