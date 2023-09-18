import 'package:flutter/material.dart';

hidekeyboard({required context}) {
  FocusScope.of(context).requestFocus(FocusNode());
}
