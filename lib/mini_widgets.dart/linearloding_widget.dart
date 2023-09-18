import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildLinerloading() {
  return Center(
    child: LinearProgressIndicator(
      color: Get.theme.colorScheme.onSecondary,
      minHeight: 2,
      backgroundColor: Get.theme.colorScheme.secondary,
    ),
  );
}
