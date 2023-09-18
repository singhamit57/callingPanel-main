import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:get/get.dart';

List<MessageVariable> getvariablelist() {
  LogeduserControll controller = Get.find<LogeduserControll>();
  return [
    MessageVariable(
        value: controller.logeduserdetail.value.compName,
        variable: '<Company Name/>'),
    MessageVariable(
        value: controller.logeduserdetail.value.compMobile,
        variable: '<Company Mobile/>'),
    MessageVariable(
        value: controller.logeduserdetail.value.compEmail,
        variable: '<Company Email/>'),
    // MessageVariable(
    //     value: controller.logeduserdetail.value.compAddress ?? '',
    //     variable: '<Company Address/>'),
    // MessageVariable(
    //     value: controller.logeduserdetail.value.compWebsite ?? '',
    //     variable: '<Company Website/>'),
    MessageVariable(
        value: controller.logeduserdetail.value.logeduserName,
        variable: '<Your Name/>'),
    MessageVariable(
        value: controller.logeduserdetail.value.logeduserMobile,
        variable: '<Your Mobile/>'),
    MessageVariable(
        value: controller.logeduserdetail.value.logeduserEmail,
        variable: '<Your Email/>'),
    MessageVariable(
        value: controller.logeduserdetail.value.logeduserId,
        variable: '<Your UserId/>')
  ];
}

String variablereplacer(String message) {
  String data = message;
  getvariablelist().forEach((element) {
    data = data.replaceAll(element.variable, element.value);
  });
  return data;
}

class MessageVariable {
  String variable;
  String value;
  MessageVariable({required this.variable, required this.value});
}
