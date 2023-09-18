import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/mini_widgets.dart/animated_button.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/templatevariable/templatevariable_page.dart';
import 'package:callingpanel/models/mobileappmodel/messagetemp_model.dart';
import 'package:callingpanel/widgets/reuseable/mytext_field.dart';
import 'package:callingpanel/widgets/reuseable/scrollabletextfield.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'messagetemp_controller.dart';

TextEditingController lablectrl = TextEditingController();
TextEditingController messagectrl = TextEditingController();

class MessageTemplateMobile extends StatefulWidget {
  final bool haveolddata;
  final MessageTemplates? predata;

  const MessageTemplateMobile(
      {Key? key, required this.haveolddata, this.predata})
      : super(key: key);

  @override
  _MessageTemplateMobileState createState() => _MessageTemplateMobileState();
}

MessageTemplCtrl? messagetempctrl;
LogeduserControll? logeduserctrl;

class _MessageTemplateMobileState extends State<MessageTemplateMobile> {
  @override
  void initState() {
    lablectrl.text = '';
    messagectrl.text = '';
    if (widget.haveolddata) {
      lablectrl.text = widget.predata!.lable;
      messagectrl.text = widget.predata!.content;
    }
    messagetempctrl = Get.put(MessageTemplCtrl());
    logeduserctrl = Get.find<LogeduserControll>();
    messagetempctrl!.changebtnstate(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: (widget.haveolddata ? "Edit Message" : "Create Message")
            .text
            .color(kdwhitecolor)
            .fontFamily('PoppinsSemiBold')
            .xl2
            .make(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                hint: 'Make message lable',
                lable: 'Lable',
                controller: lablectrl,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        showtemplatevariable(
                            context: context, controller: messagectrl);
                      },
                      icon: Icon(
                        Icons.add,
                        color: Get.theme.colorScheme.secondary,
                        size: 22,
                      ),
                      label: 'Add Variable'
                          .text
                          .color(Get.theme.colorScheme.secondary)
                          .size(12)
                          .make()),
                ],
              ),
              myscrollabletextfield(
                  hint: 'Create message template',
                  lable: 'Message Template',
                  controller: messagectrl,
                  minheight: 70,
                  maxheight: 200,
                  maxline: 10),
              const SizedBox(
                height: 20,
              ),
              buildbutton(context: context, controll: messagetempctrl!)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildbutton({
    required context,
    required MessageTemplCtrl controll,
  }) {
    return Obx(() => buildanimatebtntext(
          ontap: () async {
            if (controll.buttonstate.value == ButtonState.idle) {
              savemessage(context: context, controll: controll);
            }
          },
          key: 'MessageTemp',
          success: "Saved Successfully",
          idel: "Save",
          fail: "Failed",
          loading: "Processing",
          state: controll.buttonstate.value,
        ));
  }

  savemessage({
    required context,
    required MessageTemplCtrl controll,
  }) async {
    controll.changebtnstate(1);
    String _url = mainurl + "/configuration/addedimessagetemp_app.php";
    var body = {
      "CompId": logeduserctrl!.logeduserdetail.value.compId,
      "UserID": logeduserctrl!.logeduserdetail.value.logeduserId,
      "Haveoldmsj": widget.haveolddata,
      "Table_Id":
          widget.haveolddata ? widget.predata!.tableId.toString() : 'NA',
      "Lable": lablectrl.text,
      "message": messagectrl.text,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          await logeduserctrl!.getmessagetemplates();
          controll.changebtnstate(2);
          await Future.delayed(const Duration(milliseconds: 800));
          Navigator.pop(context);
          showsnackbar(
              titel: 'Success !!!', detail: 'Message saved successfully');
        } else {
          controll.changebtnstate(3);
          showsnackbar(titel: 'Failed !!!', detail: data['Msj']);
        }
      }
    } catch (e) {
      controll.changebtnstate(3);
      showsnackbar(titel: 'Failed !!!', detail: 'Something is wrong...');
    }
  }
}
