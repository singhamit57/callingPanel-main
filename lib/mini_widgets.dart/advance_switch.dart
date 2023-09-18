import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

Widget buildadvanceswitch({
  required AdvancedSwitchController controller,
}) {
  return AdvancedSwitch(
    controller: controller,
    activeColor: kdskyblue,
    inactiveColor: Constants.kdred,
    activeChild: const Text('Yes'),
    inactiveChild: const Text('No'),
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    width: 50.0,
    height: 30.0,
    enabled: true,
    disabledOpacity: 0.5,
  );
}
