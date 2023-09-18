import 'package:callingpanel/constants/scroll_behaviour.dart';
import 'package:flutter/cupertino.dart';

extension WidExtKd on Widget {
  Widget get custumScrollBehaviour {
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child: this,
    );
  }
}
