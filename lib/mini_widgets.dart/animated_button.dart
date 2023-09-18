import 'package:callingpanel/constants/const_colors.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildanimatebtnicon({
  required ButtonState state,
}) {
  return ProgressButton.icon(
    iconedButtons: {
      ButtonState.idle: IconedButton(
        text: 'Login',
        icon: const Icon(
          Icons.login,
          color: kdwhitecolor,
        ),
        color: Get.theme.primaryColorDark,
      ),
      ButtonState.loading: IconedButton(
        text: 'Varifing',
        // icon: Icon(Icons.login),
        color: Get.theme.primaryColorDark,
      ),
      ButtonState.fail: IconedButton(
        text: 'Failed',
        icon: const Icon(
          Icons.cancel,
          color: kdwhitecolor,
        ),
        color: Get.theme.primaryColorDark,
      ),
      ButtonState.success: IconedButton(
        text: 'Success',
        icon: const Icon(
          Icons.check_circle,
          color: kdwhitecolor,
        ),
        color: Get.theme.primaryColorDark,
      ),
    },
    onPressed: () {
      // pagecontroll.validate();
    },
    state: state,
  );
}

Widget buildanimatebtntext({
  required ButtonState state,
  required String idel,
  required String loading,
  required String fail,
  required String success,
  IconData? idelicon,
  required dynamic key,
  required Function ontap,
}) {
  TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
      letterSpacing: 1.3);
  return ProgressButton(
    key: ValueKey(key),
    maxWidth: 300.0,
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    progressIndicator: CircularProgressIndicator(
      color: Get.theme.colorScheme.secondary,
      backgroundColor: Get.theme.colorScheme.onSecondary,
    ),
    stateWidgets: {
      ButtonState.idle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (idelicon != null)
            Icon(
              idelicon,
              color: kdwhitecolor,
            ),
          const SizedBox(
            width: 5,
          ),
          Text(
            idel,
            style: style,
          )
        ],
      ),
      ButtonState.loading: Text(
        loading,
        style: style,
      ),
      ButtonState.fail: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cancel,
            color: kdwhitecolor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            fail,
            style: style,
          )
        ],
      ),
      ButtonState.success: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.done,
            color: kdwhitecolor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            success,
            style: style,
          )
        ],
      ),
    },
    stateColors: {
      ButtonState.idle: kdfbblue,
      ButtonState.loading: Get.theme.colorScheme.secondary,
      ButtonState.fail: Get.theme.colorScheme.onError,
      ButtonState.success: kdgreencolor,
    },
    onPressed: ontap,
    state: state,
  );
}
