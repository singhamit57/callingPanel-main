import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildOnlineCircle({
  required bool isonline,
}) {
  return Container(
    width: 150,
    alignment: Alignment.center,
    child: CircleAvatar(
      radius: 8,
      backgroundColor:
          isonline ? Get.theme.colorScheme.secondary : Constants.kdred,
    ),
  );
}

Widget buildLastLogin({
  required bool isonline,
  required String lastlogin,
}) {
  return Container(
    width: 150,
    padding: const EdgeInsets.all(8),
    alignment: Alignment.center,
    child: Text(
      isonline ? 'Online' : lastlogin,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'PoppinsSemiBold',
        // color: isonline ? Get.theme.colorScheme.secondary : Constants.kdred,
        color: kdwhitecolor,
      ),
    ),
  );
}
