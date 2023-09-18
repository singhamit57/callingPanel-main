import 'package:callingpanel/constants/const_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

showsnackbar({required String titel, required String detail, int? duration}) {
  Get.snackbar(
    '',
    '',
    titleText: Text(
      titel,
      style: TextStyle(
          color: Get.theme.colorScheme.onSecondary,
          fontFamily: 'PoppinsSemiBold'),
    ),
    maxWidth: 750,
    margin: const EdgeInsets.only(top: 30),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    messageText: Text(
      detail,
      style: const TextStyle(color: kdblackcolor, fontFamily: 'PoppinsRegular'),
    ),
    duration: Duration(seconds: duration ?? 3),
  );
}
