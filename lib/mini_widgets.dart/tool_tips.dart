import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';

Widget buildtooptip({
  required String message,
  required Widget child,
  bool preferBelow = false,
}) {
  return Tooltip(
    message: message,
    child: child,
    preferBelow: preferBelow,
    decoration: BoxDecoration(
        color: kdwhitecolor.withOpacity(.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: .75,
          color: kdblackcolor,
        )),
    textStyle: const TextStyle(
        color: kdblackcolor, fontSize: 12, fontWeight: FontWeight.w500),
  );
}
