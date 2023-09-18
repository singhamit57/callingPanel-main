import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Widget buildsearchingdatalottie() {
  return Container(
    height: (Get.height - 300),
    width: Get.width,
    alignment: Alignment.center,
    child: Lottie.network(
      'https://assets3.lottiefiles.com/packages/lf20_mjhzefl4.json',
      height: Get.width < 500 ? 200 : 300,
      fit: BoxFit.cover,
    ),
  );
}
