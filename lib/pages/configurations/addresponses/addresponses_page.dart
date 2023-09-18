import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/getcompanybyid.dart';
import 'package:callingpanel/mini_widgets.dart/animated_button.dart';
import 'package:callingpanel/pages/configurations/addresponses/responses_controll.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:callingpanel/widgets/reuseable/mytext_field.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

class AddEditResponses extends StatefulWidget {
  const AddEditResponses({Key? key}) : super(key: key);

  @override
  _AddEditResponsesState createState() => _AddEditResponsesState();
}

ResponsePageCtrl? respPagecontroll;
LogeduserControll? logeduserctrl;

class _AddEditResponsesState extends State<AddEditResponses> {
  @override
  void initState() {
    respPagecontroll = Get.find<ResponsePageCtrl>();
    logeduserctrl = Get.find<LogeduserControll>();
    super.initState();
  }

  @override
  void dispose() {
    respPagecontroll!.onloadpage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Obx(() => Padding(
            padding: const EdgeInsets.only(top: 20, left: 25),
            child: (respPagecontroll!.responseTitel.value)
                .text
                .xl3
                .color(kdyellowcolor)
                .make())),
        ResponsiveLayout(
          computer: Column(
            children: [
              buildonerow(
                  widget1: buildcompanyid(), widget2: buildcompanyname()),
              buildonerow(widget1: buildresponse(), widget2: buildneeddate()),
              buildonerow(widget1: buildneedremark(), widget2: buildneedsms()),
              buildonerow(widget1: buildneedmail(), widget2: const SizedBox()),
              const SizedBox(
                height: 20,
              ),
              buildsavebtun(),
            ],
          ),
        ),
      ],
    ));
  }

  Widget buildsavebtun() {
    return Obx(() => buildanimatebtntext(
        state: respPagecontroll!.buttonstate.value,
        idel: 'Save',
        key: 'responsekey',
        loading: 'Please Wait',
        success: 'Success',
        fail: 'Failed',
        ontap: () {
          respPagecontroll!.saveresponse();
        }));
  }

  Widget buildonerow({
    required Widget widget1,
    required Widget widget2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: widget1,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 3,
          child: widget2,
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  Widget buildcompanyid() {
    return Visibility(
      visible: logeduserctrl!.showcompoption.value,
      child: MyTextField(
        hint: "Enter Company Id",
        lable: "Company Id",
        keyboardtype: TextInputType.name,
        onchange: (value) {
          EasyDebounce.debounce('Compid', const Duration(milliseconds: 800),
              () {
            getcompnamebyid(compid: value).then((value) {
              respPagecontroll!.compNameCtrl.value.text = value;
            });
          });
        },
        controller: respPagecontroll!.compIdCtrl.value,
      ),
    );
  }

  Widget buildcompanyname() {
    return Visibility(
      visible: logeduserctrl!.showcompoption.value,
      child: MyTextField(
        hint: "Enter Company Name",
        lable: "Company Name",
        keyboardtype: TextInputType.name,
        controller: respPagecontroll!.compNameCtrl.value,
      ),
    );
  }

  Widget buildresponse() {
    return MyTextField(
      hint: "Enter Response",
      lable: "Response",
      keyboardtype: TextInputType.name,
      controller: respPagecontroll!.responseCtrl.value,
    );
  }

  Widget buildonepermission({
    ValueChanged? onchange,
    required bool value,
    required String lable,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child: Text(lable).text.bold.color(kdyellowcolor).make(),
        ),
        Switch(
          value: value,
          activeColor: kdskyblue,
          inactiveTrackColor: Constants.kdred,
          onChanged: (value) => onchange!(value),
        ),
      ]),
    );
  }

  Widget buildneeddate() {
    return Obx(() => buildonepermission(
        value: respPagecontroll!.needintdate.value,
        lable: "This Response Need Date ?",
        onchange: (value) {
          respPagecontroll!.needintdate.value = value;
        }));
  }

  Widget buildneedremark() {
    return Obx(() => buildonepermission(
        value: respPagecontroll!.needremark.value,
        lable: "This Response Need Remark ?",
        onchange: (value) {
          respPagecontroll!.needremark.value = value;
        }));
  }

  Widget buildneedsms() {
    return Obx(() => buildonepermission(
        value: respPagecontroll!.needsendsms.value,
        lable: "Send Sms For This Response ?",
        onchange: (value) {
          respPagecontroll!.needsendsms.value = value;
        }));
  }

  Widget buildneedmail() {
    return Obx(() => buildonepermission(
        value: respPagecontroll!.needsendmail.value,
        lable: "Send Mail For This Response ?",
        onchange: (value) {
          respPagecontroll!.needsendmail.value = value;
        }));
  }
}
