import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/getcompanybyid.dart';
import 'package:callingpanel/mini_widgets.dart/animated_button.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:callingpanel/widgets/reuseable/mytext_field.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'departmentpage_controll.dart';

class AddEditDepartment extends StatefulWidget {
  const AddEditDepartment({Key? key}) : super(key: key);

  @override
  _AddEditDepartmentState createState() => _AddEditDepartmentState();
}

DepartmetnPageCtrl? departpagectrl;
LogeduserControll? logeduserControll;

class _AddEditDepartmentState extends State<AddEditDepartment> {
  @override
  void initState() {
    departpagectrl = Get.find<DepartmetnPageCtrl>();

    logeduserControll = Get.find<LogeduserControll>();
    super.initState();
  }

  @override
  void dispose() {
    departpagectrl!.onloadpage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => Padding(
              padding: const EdgeInsets.only(top: 20, left: 25),
              child: (departpagectrl!.departmentTitel.value)
                  .text
                  .xl3
                  .color(Get.theme.colorScheme.onSecondary)
                  .make())),
          ResponsiveLayout(
            computer: Column(
              children: [
                buildonerow(
                    widget1: buildcompanyid(), widget2: buildcompanyname()),
                buildonerow(
                    widget1: builddepartment(), widget2: const SizedBox()),
                buildonerow(
                    widget1: buildresponselist(), widget2: const SizedBox()),
                const SizedBox(
                  height: 20,
                ),
                savebutton(),
              ],
            ),
            phone: Column(
              children: [
                buildcompanyid(),
                buildcompanyname(),
                builddepartment(),
                buildresponselist(),
                const SizedBox(
                  height: 20,
                ),
                savebutton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget savebutton() {
    return Obx(() => buildanimatebtntext(
          idel: 'Save',
          loading: 'Saving...',
          fail: 'Failed',
          success: 'Success',
          key: 'departkey',
          ontap: () {
            departpagectrl!.saveDepartment();
          },
          state: departpagectrl!.savebtnstatus.value,
        ));
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
      visible: logeduserControll!.showcompoption.value,
      child: MyTextField(
        hint: "Enter Company Id",
        lable: "Company Id",
        controller: departpagectrl!.compidTEC,
        onchange: (value) {
          EasyDebounce.debounce('Compid', const Duration(milliseconds: 800),
              () {
            getcompnamebyid(compid: value).then((value) {
              departpagectrl!.compidTEC.text = value;
            });
          });
        },
        keyboardtype: TextInputType.name,
        // controller: companyidctrl,
      ),
    );
  }

  Widget buildcompanyname() {
    return Visibility(
      visible: logeduserControll!.showcompoption.value,
      child: MyTextField(
        hint: "Enter Company Name",
        lable: "Company Name",
        controller: departpagectrl!.compnameTEC,
        keyboardtype: TextInputType.name,
        // controller: companynamectrl,
      ),
    );
  }

  Widget builddepartment() {
    return MyTextField(
      hint: "Enter Department Name",
      lable: "Department",
      controller: departpagectrl!.departmentTEC.value,
      keyboardtype: TextInputType.name,
      // controller: companynamectrl,
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
          child: Text(lable)
              .text
              .bold
              .color(Get.theme.colorScheme.onSecondary)
              .make(),
        ),
        Switch(
          value: value,
          activeColor: kdskyblue,
          inactiveThumbColor: Colors.blueGrey,
          inactiveTrackColor: Colors.red,
          activeTrackColor: Colors.green,
          onChanged: (value) => onchange!(value),
        ),
      ]),
    );
  }

  Widget buildresponselist() {
    return Obx(() {
      return Column(
        children:
            List.generate(logeduserControll!.compResponses.length, (index) {
          var ondedata = logeduserControll!.compResponses[index];
          return buildonepermission(
              lable: ondedata.response,
              value:
                  departpagectrl!.selectedresponse.contains(ondedata.response),
              onchange: (value) {
                if (departpagectrl!.selectedresponse
                    .contains(ondedata.response)) {
                  departpagectrl!.selectedresponse.remove(ondedata.response);
                } else {
                  departpagectrl!.selectedresponse.add(ondedata.response);
                }
              });
        }).toList(),
      );
    });
  }
}
