import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showmydilogue({
  required context,
  bool barrierDismissible = true,
  required Widget titel,
  required Widget details,
  List<Widget>? action,
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Theme(
          data:
              Theme.of(context).copyWith(cardColor: Get.theme.primaryColorDark),
          child: AlertDialog(
            title: titel,
            content: details,
            actions: action,
            backgroundColor: Get.theme.primaryColorDark,
            elevation: 10,
          ),
        );
      });
}

showloading({
  required context,
  required String titel,
}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  color: kdaccentcolor,
                ),
              ),
              Expanded(
                  child: Text(
                titel,
                style: const TextStyle(
                  fontSize: 20,
                ),
              )),
            ],
          ),
        );
      });
}

showconfirmation(
    {required context,
    required String titel,
    required String detail,
    required Widget leftwidget,
    required Widget rightwidget}) async {
  return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          width: 400,
          color: kdwhitecolor,
          child: Material(
            child: AlertDialog(
              title: Text(titel),
              content: Text(detail),
              actions: [leftwidget, rightwidget],
            ),
          ),
        );
      });
}
