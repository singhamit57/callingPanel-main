import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildyesbutton({required context, required Function ontap}) {
  return InkWell(
    onTap: () => ontap,
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
        color: Get.theme.primaryColorDark,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: const Text(
        "Yes",
        style: TextStyle(color: kdwhitecolor, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget buildnobutton({required context, required Function ontap}) {
  return InkWell(
    onTap: () => ontap,
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Get.theme.primaryColorDark, width: 1.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        "No",
        style: TextStyle(color: kdwhitecolor, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
