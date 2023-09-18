import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

Widget datepickershowtext({
  required context,
  required Function ontap,
  required String value,
  double? fontsize,
  Color? fontcolor,
  Color? iconcolor,
}) {
  return Container(
    padding: const EdgeInsets.all(0),
    margin: const EdgeInsets.fromLTRB(5, 5, 0, 5),
    decoration: BoxDecoration(
        border: Border.all(
            width: 1.0, color: Get.theme.colorScheme.primary.withOpacity(.4)),
        borderRadius: BorderRadius.circular(5.0)),
    child: Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        value.text
            .color(fontcolor ?? kdblackcolor)
            .size(fontsize ?? 16)
            .makeCentered(),
        const Spacer(),
        IconButton(
            onPressed: () => ontap(),
            icon: Icon(
              Icons.calendar_today,
              color: iconcolor ?? kdfbblue,
            ))
      ],
    ),
  );
}
