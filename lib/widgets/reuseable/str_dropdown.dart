import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buidldropdown(
    {required List<String> itemslist,
    String? initvalue,
    required context,
    String? hinttext,
    required ValueChanged<String> onchange}) {
  return Container(
    // margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    decoration: BoxDecoration(
        border: Border.all(
            width: 1.0, color: Get.theme.colorScheme.primary.withOpacity(.4)),
        borderRadius: BorderRadius.circular(5.0)),
    child: Theme(
      data: Theme.of(context).copyWith(
        cardColor: Get.theme.colorScheme.background,
        canvasColor: Get.theme.colorScheme.background,
        focusColor: Get.theme.colorScheme.background,
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: itemslist.contains(initvalue) ? initvalue : null,
        dropdownColor: Get.theme.colorScheme.background,
        focusColor: Get.theme.colorScheme.background,
        iconEnabledColor: Get.theme.primaryColor,
        style:
            const TextStyle(color: kdblackcolor, fontFamily: 'PoppinsRegular'),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          fillColor: Get.theme.colorScheme.background,
          focusColor: Get.theme.colorScheme.background,
        ),
        items: itemslist
            .map((e) => DropdownMenuItem<String>(
                  child: Text(
                    e,
                    style: const TextStyle(
                        color: kdblackcolor, fontFamily: 'PoppinsRegular'),
                  ),
                  value: e,
                ))
            .toList(),
        hint: Text(hinttext ?? ''),
        onChanged: (value) => onchange(value!),
      ),
    ),
  );
}
