import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

class MessageTemplCtrl extends GetxController {
  var buttonstate = ButtonState.idle.obs;
  changebtnstate(int index) async {
    if (index <= 3) {
      buttonstate.value = states[index];
      if (index == 3) {
        await Future.delayed(const Duration(seconds: 3));
        buttonstate.value = states[0];
      }
    }
  }
}

List<ButtonState> states = [
  ButtonState.idle,
  ButtonState.loading,
  ButtonState.success,
  ButtonState.fail,
];
