import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

showCSCPikcer({
  required ValueChanged<String> onCountychange,
  required ValueChanged<String> onStatechange,
  required ValueChanged<String> onCitychange,
  required context,
}) async {
  String _country = "";
  String _state = "";
  String _city = "";

  await Get.dialog(
    Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(8),
          // height: 400,
          // width: 400,
          constraints: const BoxConstraints(
            maxWidth: 350,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.primary.withOpacity(.7),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  "County > State > City"
                      .text
                      .color(kdblackcolor)
                      .fontWeight(FontWeight.w600)
                      .size(14)
                      .make()
                      .expand(),
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Constants.kdred,
                      )),
                ],
              ),
              10.heightBox,
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    brightness: Brightness.light,
                    dialogBackgroundColor: Get.theme.colorScheme.surface,
                  ),
                  child: CSCPicker(
                    selectedItemStyle:
                        TextStyle(color: Get.theme.colorScheme.onPrimary),
                    dropdownItemStyle:
                        TextStyle(color: Get.theme.colorScheme.primary),
                    dropdownHeadingStyle: TextStyle(
                        color: Get.theme.colorScheme.secondary, fontSize: 20),
                    dropdownDecoration: const BoxDecoration(
                      color: snow,
                    ),
                    disabledDropdownDecoration: const BoxDecoration(
                      color: snow,
                    ),
                    layout: Layout.vertical,
                    flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                    defaultCountry: DefaultCountry.India,
                    onCountryChanged: (value) {
                      _country = value;
                    },
                    onStateChanged: (value) {
                      _state = value ?? "";
                    },
                    onCityChanged: (value) {
                      _city = value ?? "";
                    },
                  ),
                ),
              ),
              10.heightBox,
              Container(
                width: 120,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: () {
                      onCountychange(_country);
                      onStatechange(_state);
                      onCitychange(_city);
                      Navigator.pop(context);
                    },
                    child: "Save"
                        .text
                        .color(kdwhitecolor)
                        .fontWeight(FontWeight.w500)
                        .size(14)
                        .makeCentered()),
              ),
            ],
          ),
        ),
      ),
      // child: SimpleDialog(
      //   title:,
      //   backgroundColor: Get.theme.colorScheme.surface,
      //   children: [],
      // ),
    ),
    barrierColor: kdwhitecolor.withOpacity(.4),
  );
}
