import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

Widget buildreportcard({
  required context,
  required String count,
  required String lable,
  Color? countColor,
  Color? lableColor,
  double? countsize,
  double? lablesize,
  required Function() ontap,
}) {
  return InkWell(
    onTap: ontap,
    child: Card(
      elevation: 5,
      color: Get.theme.colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const []),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            count.text
                .color(lableColor ?? kdskyblue)
                .size(countsize ?? 30)
                .bold
                .makeCentered(),
            lable.text
                .color(lableColor ?? kdwhitecolor)
                .size(lablesize ?? 24)
                .align(TextAlign.center)
                .makeCentered(),
          ],
        ),
      ),
    ),
  );
}
