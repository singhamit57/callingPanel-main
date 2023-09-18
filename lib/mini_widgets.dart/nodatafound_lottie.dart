import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Widget buildnodatlottie({
  double? height,
  bool repeat = true,
}) {
  return Container(
    height: height ?? (Get.height - 300),
    width: Get.width,
    alignment: Alignment.center,
    child: Lottie.asset(
      'assets/notfound.json',
      height: Get.width < 500 ? 200 : 300,
      fit: BoxFit.cover,
      repeat: repeat,
    ),
  );
}
