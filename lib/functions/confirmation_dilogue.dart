import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> makeconfirmation({
  required context,
  required String titel,
  required String content,
  required bool yestobutton,
}) async {
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Get.theme.colorScheme.surface,
          title: Text(
            titel,
            style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
                fontFamily: 'PoppinsSemiBold'),
          ),
          content: Text(
            content,
            softWrap: true,
            style: TextStyle(
              color: Get.theme.colorScheme.onSecondary,
              fontSize: 14,
              fontFamily: 'PoppinsRegular',
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColorDark),
              onPressed: () {
                Navigator.pop(context, yestobutton);
              },
              child: Text(
                yestobutton ? 'Yes' : 'NO',
                style: const TextStyle(
                    color: kdwhitecolor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, !yestobutton);
              },
              child: Text(
                yestobutton ? 'NO' : 'Yes',
                style: TextStyle(
                    color: Get.theme.primaryColorDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      });
}
