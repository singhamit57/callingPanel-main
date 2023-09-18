import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

Widget buildeditdeletebtn({
  required context,
  Function()? ondedit,
  Function()? ondelete,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        // width: 100,
        alignment: Alignment.centerRight,
        // padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
        child: Row(
          children: [
            IconButton(
              onPressed: ondedit,
              icon: Icon(
                Icons.edit,
                color: Get.theme.colorScheme.secondary,
                size: 24,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: ondelete,
              icon: Icon(
                Icons.delete,
                color: Get.theme.colorScheme.onError,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildheadtext({required String value, required bool allowed}) {
  return value.text
      .color(allowed ? kdskyblue : Constants.kdred)
      .size(12)
      .make();
}

Widget buildbodytext({required String value, required IconData icon}) {
  return Row(
    children: [
      Icon(
        icon,
        color: kdskyblue,
        size: 20,
      ),
      const SizedBox(
        width: 3,
      ),
      value.text.white.size(18).make()
    ],
  );
}
