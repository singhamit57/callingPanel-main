import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/models/department_model.dart';
import 'package:callingpanel/models/responserequrement_model.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'adddepartments/departmentpage_controll.dart';
import 'addresponses/responses_controll.dart';
import 'configuration_controller.dart';

WorkPageController? workpagectrl;

class ConfigutaionPage extends StatefulWidget {
  const ConfigutaionPage({Key? key}) : super(key: key);

  @override
  _ConfigutaionPageState createState() => _ConfigutaionPageState();
}

// AddEditUserController? userctrl;
LogeduserControll? logeduserctrl;
ConfigurationPageCtrl? configpagectrl;

class _ConfigutaionPageState extends State<ConfigutaionPage> {
  @override
  void initState() {
    // _getrecords();
    workpagectrl = Get.find<WorkPageController>();
    // userctrl = Get.put(AddEditUserController());
    logeduserctrl = Get.find<LogeduserControll>();
    configpagectrl = Get.find<ConfigurationPageCtrl>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: null,
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Visibility(
              //     visible: (logeduserctrl!.islogedin), child: buildLinerloading()),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Responses",
                      style: TextStyle(
                        color: Get.theme.colorScheme.onSecondary,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: () {
                        //AddeditResponse
                        workpagectrl!.setworkpage('AddeditResponse');
                      },
                      icon: const Icon(Icons.add),
                      label: 'Add'.text.makeCentered()),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                    controller: null,
                    shrinkWrap: true,
                    itemCount: logeduserctrl!.compResponses.length,
                    itemBuilder: (context, index) {
                      ResponseRequrements oneresponse =
                          logeduserctrl!.compResponses[index];
                      return buildresponsecard(data: oneresponse);
                    }),
              ),
              Divider(
                thickness: 2.0,
                color: kdblackcolor.withOpacity(.1),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Departments",
                      style: TextStyle(
                        color: Get.theme.colorScheme.onSecondary,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: () {
                        workpagectrl!.setworkpage(PageSwitch.addeditdepart);
                      },
                      icon: const Icon(Icons.add),
                      label: 'Add'.text.makeCentered()),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: null,
                    itemCount: logeduserctrl!.comDepartmentList.length,
                    itemBuilder: (context, index) {
                      return builddepartcard(
                          onedata: logeduserctrl!.comDepartmentList[index]);
                    }),
              ),
              40.heightBox,
            ],
          ),
        ));
  }

  Widget buildresponsecard({
    required ResponseRequrements data,
  }) {
    return ListTile(
      title: (data.response).text.color(kdfbblue).size(16).make(),
      subtitle: RichText(
          text: TextSpan(
        text: 'Requrements : ',
        style: const TextStyle(color: Constants.kdorange),
        children: [
          TextSpan(
              text: 'Date, ',
              style: TextStyle(
                color: data.needIntDate ? kdgreencolor : Constants.kdred,
              )),
          TextSpan(
              text: 'Remark, ',
              style: TextStyle(
                color: data.needRemark ? kdgreencolor : Constants.kdred,
              )),
          TextSpan(
              text: 'Send Sms, ',
              style: TextStyle(
                color: data.sendSms ? kdgreencolor : Constants.kdred,
              )),
          TextSpan(
              text: 'Send Mail',
              style: TextStyle(
                color: data.sendMail ? kdgreencolor : Constants.kdred,
              )),
        ],
      )),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                Get.find<ResponsePageCtrl>().onloadpage(editdata: data);
                workpagectrl!.setworkpage('AddeditResponse');
              },
              icon: const Icon(
                Icons.edit,
                color: kdblackcolor,
              )),
          IconButton(
              onPressed: () async {
                var result = await makeconfirmation(
                    context: context,
                    titel: 'Confirmation',
                    content: 'Do you want to delete this response ?',
                    yestobutton: false);
                if (result == true) {
                  configpagectrl!.deleteResponseDepartment(
                      lable: data.response, operation: 'Response');
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
    );
  }

  Widget builddepartcard({
    required DepartmentsModel onedata,
  }) {
    return ExpansionTile(
      collapsedIconColor: Get.theme.colorScheme.onSecondary,
      title: (onedata.department!).text.color(kdfbblue).size(18).make(),
      // children: List.generate(onedata.responses!.length, (index) {
      //   return buildrespfordeprt(response: onedata.responses![index]);
      // }).toList(),
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(10, 5, 30, 3),
          child: (onedata.responses!.join(", "))
              .text
              .color(kdblackcolor)
              .maxLines(5)
              .size(16)
              .make(),
        ),
        const Divider(
          color: kdblackcolor,
          thickness: 1.5,
          height: 7,
        ),
      ],
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                Get.find<DepartmetnPageCtrl>().onloadpage(editdata: onedata);
                workpagectrl!.setworkpage(PageSwitch.addeditdepart);
              },
              icon: const Icon(
                Icons.edit,
                color: kdblackcolor,
              )),
          IconButton(
              onPressed: () async {
                var result = await makeconfirmation(
                    context: context,
                    titel: 'Confirmation',
                    content: 'Do you want to delete this department ?',
                    yestobutton: false);
                if (result == true) {
                  configpagectrl!.deleteResponseDepartment(
                      lable: onedata.department ?? '', operation: 'Department');
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
    );
  }

  Widget buildrespfordeprt({required String response}) {
    return ListTile(
      title: response.text.white.make(),
      trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.delete,
            color: Constants.kdred,
          )),
    );
  }
}
