import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';

showloadingdilogue({
  required context,
}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: const Center(
            child: SizedBox(
              height: 85,
              width: 85,
              child: CircularProgressIndicator(
                color: kdyellowcolor,
                backgroundColor: kdwhitecolor,
              ),
            ),
          ),
        );
      });
}
