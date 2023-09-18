import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/functions/messageveriable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

showtemplatevariable(
    {required context, required TextEditingController controller}) {
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Get.theme.primaryColorDark,

          // insetPadding: EdgeInsets.zero,
          title: 'Select a variable'.text.color(kdskyblue).xl2.make(),
          children: [
            ListView.builder(
              itemCount: getvariablelist().length,
              shrinkWrap: true,
              itemBuilder: (context, index) => onevariable(
                  context: context,
                  lable: getvariablelist()[index].variable,
                  controller: controller),
            ),
          ],
        );
      });
}

Widget onevariable(
    {required context,
    required String lable,
    required TextEditingController controller}) {
  return SimpleDialogOption(
      onPressed: () async {
        controller.text = controller.text + lable;
        Navigator.pop(context);
      },
      child: lable.text.size(14).white.heightLoose.make());
}
