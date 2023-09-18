import 'package:flutter/material.dart';

extension StrExtKd on String {
  Text toTextWid({
    double size = 12,
    int maxlines = 1,
    FontWeight weight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return Text(
      this,
      maxLines: maxlines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
