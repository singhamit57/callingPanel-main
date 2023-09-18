import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';

Map<int, Color> color = const {
  50: Color.fromRGBO(49, 0, 6, .1),
  100: Color.fromRGBO(49, 0, 6, .2)
};

MaterialColor colorCustom = MaterialColor(0xFFf7ca18, color);

ThemeData lightThemeData = ThemeData(
  primaryColor: kdfbblue,
  iconTheme: const IconThemeData(color: Colors.black54, size: 20),
  scaffoldBackgroundColor: kdwhitecolor,
  canvasColor: lavenderDark,
  primarySwatch: Colors.brown,

  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: logoorangecolor,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: kdskyblue,
    focusColor: kdwhitecolor,
  ),
  focusColor: kdwhitecolor,
  primaryColorDark: lightseagreen,
  fontFamily: 'PoppinsRegular',
  colorScheme: const ColorScheme(
      primary: kdfbblue,
      secondary: lightseagreen,
      surface: lavenderDark,
      background: snow,
      error: Constants.kdred,
      onPrimary: lightseagreen,
      onSecondary: logoorangecolor,
      onSurface: Colors.black54,
      onBackground: kdblackcolor,
      onError: Constants.kdred,
      brightness: Brightness.dark),

  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(Colors.blueGrey.shade600),
    trackBorderColor: MaterialStateProperty.all(Colors.blueGrey.shade200),
    crossAxisMargin: 8,
    mainAxisMargin: 5,
    thickness: MaterialStateProperty.all(8),
  ),
  appBarTheme: const AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
          color: logoorangecolor, fontSize: 16, fontFamily: 'PoppinsSemiBold'),
      backgroundColor: kdfbblue,
      iconTheme: IconThemeData(color: snow)),
  splashColor: kdskyblue,
  // primarySwatch: Colors.white,
  hintColor: kdgreycolor,
);




// final oldthemedata = ThemeData(
                //   primaryColor: kdprimarylightcolor,
//   // iconTheme: IconThemeData(color: kdwhitecolor, size: 20),
//   scaffoldBackgroundColor: Get.theme.primaryColorDark,
//   canvasColor: Get.theme.primaryColor,
//   inputDecorationTheme: const InputDecorationTheme(fillColor: kdskyblue),
//   focusColor: kdwhitecolor,
//   primaryColorDark: Get.theme.primaryColorDark,
//   scrollbarTheme: ScrollbarThemeData(
//     thumbColor: MaterialStateProperty.all(Colors.white.withOpacity(.6)),
//     crossAxisMargin: 3,
//     mainAxisMargin: 5,
//     thickness: MaterialStateProperty.all(5),
//   ),
//   appBarTheme: const AppBarTheme(
//       backgroundColor: Get.theme.primaryColorDark,
//       iconTheme: IconThemeData(color: kdwhitecolor)),
//   splashColor: kdskyblue,
//   primarySwatch: Colors.purple,
//   hintColor: kdgreycolor,
// );
