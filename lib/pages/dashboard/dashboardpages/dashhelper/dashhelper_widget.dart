import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/pages/dashboard/dashboardpages/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildleftheadcard() {
  return Padding(
    padding: const EdgeInsets.only(
        left: Constants.kdPadding / 2,
        top: Constants.kdPadding / 2,
        right: Constants.kdPadding / 2),
    child: Card(
      color: Get.theme.primaryColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ListTile(
          //leading: Icon(Icons.shopping_basket),
          title: const Text(
            "Products Sold",
            style: TextStyle(color: Colors.white),
          ),

          trailing: Chip(
            label: Obx(() => Text(
                  Get.find<DashBoardCtrl>().productsold.value,
                  style: const TextStyle(color: Colors.white),
                )),
          ),
        ),
      ),
    ),
  );
}

Widget buildcenterheadcard() {
  return Padding(
    padding: const EdgeInsets.only(
        top: Constants.kdPadding / 2,
        right: Constants.kdPadding / 2,
        left: Constants.kdPadding / 2),
    child: Card(
      color: Get.theme.primaryColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ListTile(
          //leading: Icon(Icons.sell),
          title: const Text(
            "Total Users",
            style: TextStyle(color: Colors.white),
          ),
          trailing: Chip(
            label: Obx(() => Text(
                  Get.find<DashBoardCtrl>().totaluser.value,
                  style: const TextStyle(color: Colors.white),
                )),
          ),
        ),
      ),
    ),
  );
}

Widget buildrightheadcard() {
  return Padding(
    padding: const EdgeInsets.only(
        right: Constants.kdPadding / 2,
        top: Constants.kdPadding / 2,
        left: Constants.kdPadding / 2),
    child: Card(
      color: Get.theme.primaryColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ListTile(
          //leading: Icon(Icons.monetization_on),
          title: const Text(
            "Lead Length",
            style: TextStyle(color: Colors.white),
          ),

          trailing: Chip(
            label: Obx(() => Text(
                  Get.find<DashBoardCtrl>().leadlength.value,
                  style: const TextStyle(color: Colors.white),
                )),
          ),
        ),
      ),
    ),
  );
}
