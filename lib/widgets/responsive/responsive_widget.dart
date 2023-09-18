// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  //final Widget tiny;
  final Widget? phone;
  final Widget? tablet;
  // final Widget largeTablet;
  final Widget? computer;

  const ResponsiveLayout({
    //  required this.tiny,
    this.phone,
    this.tablet,
    // required this.largeTablet,
    this.computer,
  });

  // static final int tinyHeightLimit = 100;
  // static final int tinyLimit = 270;
  static int phoneLimit = 550;
  static int tabletLimit = 800;
  static int largeTabletLimit = 1100;

  // static bool isTinyHeightLimit(BuildContext context) =>
  //     MediaQuery.of(context).size.height < tinyHeightLimit;

  // static bool isTinyLimit(BuildContext context) =>
  //     MediaQuery.of(context).size.width < tinyLimit;

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit &&
      MediaQuery.of(context).size.width >= phoneLimit;

  static bool isLargeTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < largeTabletLimit &&
      MediaQuery.of(context).size.width >= tabletLimit;

  static bool isComputer(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeTabletLimit;

  static double currentheight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double currentwidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // if (constraints.maxWidth < tinyLimit ||
        //     constraints.maxHeight < tinyHeightLimit) {
        //   return tiny;
        // }
        if (constraints.maxWidth < phoneLimit) {
          return phone ?? tablet ?? computer ?? const SizedBox();
        }
        if (constraints.maxWidth < tabletLimit) {
          return tablet ?? computer ?? phone ?? const SizedBox();
        }
        if (constraints.maxWidth < largeTabletLimit) {
          return computer ?? phone ?? tablet ?? const SizedBox();
        } else {
          return computer ?? phone ?? tablet ?? const SizedBox();
        }
      },
    );
  }
}
