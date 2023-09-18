import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/mini_widgets.dart/animated_button.dart';
import 'package:callingpanel/widgets/reuseable/mytext_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'changepassword_controll.dart';

class ChangePasswordMobile extends StatefulWidget {
  const ChangePasswordMobile({Key? key}) : super(key: key);

  @override
  _ChangePasswordMobileState createState() => _ChangePasswordMobileState();
}

ChangePasswordCtrlM? pagectrl;

class _ChangePasswordMobileState extends State<ChangePasswordMobile> {
  @override
  void initState() {
    pagectrl = Get.put(ChangePasswordCtrlM());
    pagectrl!.currentpwctrl.text = '';
    pagectrl!.newpwctrl.text = '';
    pagectrl!.confirmpwctrl.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        // backgroundColor: Get.theme.primaryColorDark,
        title: "Change Passowrd"
            .text
            .color(kdwhitecolor)
            .fontFamily('PoppinsSemiBold')
            .xl
            .make(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            MyTextField(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              hint: 'Enter your password',
              lable: 'Current Password',
              ispassword: true,
              keyboardtype: TextInputType.name,
              controller: pagectrl!.currentpwctrl,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              hint: 'Enter new password',
              lable: 'New Password',
              controller: pagectrl!.newpwctrl,
              keyboardtype: TextInputType.name,
              ispassword: false,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              hint: 'Confirm password',
              lable: 'Confirm Password',
              ispassword: true,
              keyboardtype: TextInputType.name,
              controller: pagectrl!.confirmpwctrl,
            ),
            const SizedBox(
              height: 10,
            ),
            buildbutton(controll: pagectrl!, context: context),
          ],
        ),
      ),
    );
  }

  Widget buildbutton({
    required ChangePasswordCtrlM controll,
    required context,
  }) {
    return Obx(() => buildanimatebtntext(
          ontap: () async {
            // ignore: unrelated_type_equality_checks
            if (controll.buttonstate == ButtonState.idle) {
              if (controll.currentpwctrl.text.isEmpty ||
                  controll.newpwctrl.text.isEmpty) {
                showsnackbar(
                    titel: 'Alert !!!',
                    detail: 'Please enter password details...');

                return;
              }

              if (controll.newpwctrl.text != controll.confirmpwctrl.text) {
                showsnackbar(
                    titel: 'Alert !!!',
                    detail: 'Please check your new passowrd...');

                return;
              }

              controll.changebtnstate(3);
              bool result = await controll.changepassword();
              if (result) {
                Navigator.pop(context);
                showsnackbar(
                    titel: 'Success !!!',
                    detail: 'Password changed sucessfully...');
              }
            }
          },
          key: 'ChangePw',
          success: "Password Changed",
          idel: "Change Password",
          fail: "Failed",
          loading: "Processing",
          state: controll.buttonstate.value,
        ));
  }
}
