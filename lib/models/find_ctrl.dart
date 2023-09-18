import 'package:callingpanel/controllers/badic_req_ctrl.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/outgoingcallview/outgoingcallview_controller.dart';
import 'package:get/get.dart';

class FindCtrl {
  static LogeduserControll logeduser = Get.find<LogeduserControll>();
  static BasicReqCtrl basicreq = Get.find<BasicReqCtrl>();
  static OutgoincallviewCtrl outgoingview = Get.find<OutgoincallviewCtrl>();
}
