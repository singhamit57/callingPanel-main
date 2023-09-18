import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget myscrollabletextfield({
  required String hint,
  required String lable,
  TextEditingController? controller,
  TextStyle? style,
  TextInputType? keyboard,
  double minheight = 40.0,
  double? maxheight,
  bool enable = true,
  OutlineInputBorder? focusborder,
  OutlineInputBorder? unfocusborder,
  var maxline = 1,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: minheight,
      maxHeight: maxheight ?? minheight,
    ),
    child: Scrollbar(
      child: Container(
        padding: const EdgeInsets.fromLTRB(7, 10, 2, 0),
        child: TextFormField(
          cursorColor: Constants.kdorange,
          controller: controller,
          autofocus: false,
          enabled: enable,
          style: style ??
              TextStyle(
                  color: Get.theme.colorScheme.onBackground,
                  fontSize: 14,
                  fontFamily: 'PoppinsRegular'),
          keyboardType: keyboard ?? TextInputType.multiline,
          maxLines: maxline,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            focusedBorder: focusborder ??
                OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            (Get.theme.colorScheme.primary).withOpacity(.2))),
            enabledBorder: unfocusborder ??
                OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            (Get.theme.colorScheme.primary).withOpacity(.2))),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintText: hint,
            hintStyle:
                TextStyle(color: kdblackcolor.withOpacity(.4), fontSize: 14),
            labelText: lable,
            labelStyle: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontSize: 16,
                fontFamily: 'PoppinsSemiBold'),
          ),
        ),
      ),
    ),
  );
}
