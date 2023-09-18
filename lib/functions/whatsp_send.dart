import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'messageveriable.dart';

// ...somewhere in your Flutter app...
launchWhatsApp({
  required mobile,
  required msj,
}) async {
  final link = WhatsAppUnilink(
    phoneNumber: mobile,
    text: msj,
  );

  await launchUrl(Uri.parse('$link'));
}

mobilenumberselection({
  required context,
  required String mobile,
  required String altmobile,
}) async {
  if (altmobile.length >= 5) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Get.theme.colorScheme.surface,
            title: 'Select Number'
                .text
                .size(24)
                .bold
                .color(kdskyblue)
                .makeCentered(),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  messagetempselection(context: context, mobile: mobile);
                },
                child: (mobile)
                    .text
                    .color(Get.theme.colorScheme.onSecondary)
                    .size(14)
                    .fontFamily('PoppinsRegular')
                    .make(),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  messagetempselection(context: context, mobile: altmobile);
                },
                child: (altmobile)
                    .text
                    .color(Get.theme.colorScheme.onSecondary)
                    .size(14)
                    .fontFamily('PoppinsRegular')
                    .make(),
              ),
            ],
          );
        });
  } else {
    messagetempselection(context: context, mobile: mobile);
  }
}

messagetempselection({
  required context,
  required String mobile,
}) async {
  List<SimpleDialogOption> options = [
    SimpleDialogOption(
      onPressed: () async {
        Navigator.pop(context);
        launchWhatsApp(mobile: mobile, msj: 'Hello !!!');
      },
      child: ("New Message")
          .text
          .color(Get.theme.colorScheme.onSecondary)
          .size(14)
          .fontFamily('PoppinsRegular')
          .make(),
    ),
    ...List.generate(Get.find<LogeduserControll>().messagetemplates.length,
        (index) {
      var ondemessage = Get.find<LogeduserControll>().messagetemplates[index];
      return SimpleDialogOption(
        onPressed: () async {
          Navigator.pop(context);
          launchWhatsApp(
              mobile: mobile, msj: variablereplacer(ondemessage.content));
        },
        child: (ondemessage.lable)
            .text
            .color(Get.theme.colorScheme.onSecondary)
            .size(14)
            .fontFamily('PoppinsRegular')
            .make(),
      );
    }),
  ];
  showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: Get.width * .85,
          height: Get.height,
          child: SimpleDialog(
            backgroundColor: Get.theme.colorScheme.surface,
            title: 'Select Message'
                .text
                .xl
                .fontFamily('PoppinsSemiBold')
                .color(Get.theme.colorScheme.primary)
                .makeCentered(),
            children: options,
          ),
        );
      });
}
