// ignore_for_file: use_key_in_widget_constructors

import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String lable;
  final TextStyle? hintstyle;
  final TextStyle? lablestyle;
  final TextInputType? keyboardtype;
  final bool? ispassword;
  final EdgeInsets? padding;
  final ValueChanged? onchange;
  final bool? autofocus;
  final bool? enable;
  final Widget? prifix;
  final Widget? sufix;
  final List<TextInputFormatter>? formatter;
  final int? maxlength;

  const MyTextField({
    this.controller,
    required this.hint,
    required this.lable,
    this.hintstyle,
    this.lablestyle,
    this.keyboardtype,
    this.padding,
    this.ispassword,
    this.autofocus,
    this.onchange,
    this.prifix,
    this.enable,
    this.sufix,
    this.formatter,
    this.maxlength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.only(left: 25),
      // constraints: BoxConstraints(maxWidth: maxwidth),
      child: TextField(
        style: const TextStyle(fontSize: 16, color: kdblackcolor),
        controller: controller,
        keyboardType: keyboardtype,
        obscureText: ispassword ?? false,
        autofocus: autofocus ?? false,
        enabled: enable,
        onChanged: onchange,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: formatter,
        maxLength: maxlength,
        decoration: InputDecoration(
            hintText: hint,
            labelText: lable,
            prefixIcon: prifix,
            counterText: '',
            // suffix: sufix,
            suffixIcon: sufix,
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Get.theme.colorScheme.onSecondary.withOpacity(.3))),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Get.theme.colorScheme.primary.withOpacity(.3))),
            labelStyle: lablestyle ??
                const TextStyle(
                  color: kdblackcolor,
                  fontSize: 14,
                ),
            hintStyle: hintstyle ??
                TextStyle(
                    color: Get.theme.colorScheme.onSurface.withOpacity(.5),
                    fontSize: 14)),
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String lable;
  final TextStyle? hintstyle;
  final TextStyle? lablestyle;
  final TextInputType? keyboardtype;
  final bool? ispassword;
  final EdgeInsets? padding;
  final bool? enable;
  final Widget? prifix;
  // ignore: prefer_const_constructors_in_immutables
  MyTextFormField({
    this.controller,
    required this.hint,
    required this.lable,
    this.hintstyle,
    this.lablestyle,
    this.keyboardtype,
    this.padding,
    this.ispassword,
    this.prifix,
    this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.only(left: 25),
      // constraints: BoxConstraints(maxWidth: maxwidth),
      child: TextFormField(
        style: const TextStyle(fontSize: 16, color: kdwhitecolor),
        controller: controller,
        keyboardType: keyboardtype,
        obscureText: ispassword ?? false,
        enabled: enable,
        decoration: InputDecoration(
            hintText: hint,
            labelText: lable,
            prefixIcon: prifix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelStyle: lablestyle ??
                const TextStyle(
                  color: kdskyblue,
                  fontSize: 16,
                ),
            hintStyle: hintstyle ??
                TextStyle(color: kdwhitecolor.withOpacity(.5), fontSize: 14)),
      ),
    );
  }
}

/*
 Container buildtextfield({
    required String hint,
    required String lable,
    double maxwidth = 400,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 25),
      constraints: BoxConstraints(maxWidth: maxwidth),
      child: TextField(
        style: const TextStyle(fontSize: 16, color: kdwhitecolor),
        controller: controller,
        decoration: InputDecoration(
            hintText: "User Name",
            labelText: "Enter Name",
            labelStyle: const TextStyle(
                color: kdskyblue, fontSize: 16, fontWeight: FontWeight.bold),
            hintStyle:
                TextStyle(color: kdwhitecolor.withOpacity(.5), fontSize: 14)),
      ),
    );
  }
*/