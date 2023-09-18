import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/extensions/string_ext.dart';
import 'package:flutter/material.dart';

class OneVertLableContent extends StatelessWidget {
  final String lable;
  final String content;
  const OneVertLableContent(
      {Key? key, required this.lable, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        lable.toTextWid(
          color: Colors.blueGrey,
        ),
        content.toTextWid(
          color: kdblackcolor,
        ),
      ],
    );
  }
}
