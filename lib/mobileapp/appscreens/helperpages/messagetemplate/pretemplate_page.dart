import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/models/mobileappmodel/messagetemp_model.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'messagetemp_controller.dart';
import 'messagetemplate_page.dart';
import 'package:http/http.dart' as http;

class PreMessageTemplate extends StatefulWidget {
  const PreMessageTemplate({Key? key}) : super(key: key);

  @override
  _PreMessageTemplateState createState() => _PreMessageTemplateState();
}

MessageTemplCtrl? messagetempctrl;
LogeduserControll? logeduserctrl;

class _PreMessageTemplateState extends State<PreMessageTemplate> {
  @override
  void initState() {
    messagetempctrl = Get.put(MessageTemplCtrl());
    logeduserctrl = Get.find<LogeduserControll>();
    super.initState();
  }

  deletetemplate({
    required String messageid,
  }) async {
    showsnackbar(titel: 'Working !!!', detail: "Deleting message...");
    String _url = mainurl + '/configuration/deletemessagetemplate.php';
    var body = {
      "TemplateMessageId": messageid,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          showsnackbar(
              titel: 'Success !!!', detail: "Message deleted successfully...");
          Get.find<LogeduserControll>().getmessagetemplates();
        } else {
          showsnackbar(
              titel: 'Failed !!!', detail: "Failed to delete message...");
        }
      } else {
        showsnackbar(titel: "Error !!!", detail: "Server not responding...");
      }
    } catch (e) {
      debugPrint("deletetemplate : $e");
      showsnackbar(titel: "Error !!!", detail: "Something is worng...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: "Message Templates"
            .text
            .color(kdwhitecolor)
            .fontFamily('PoppinsSemiBold')
            .xl2
            .make(),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MessageTemplateMobile(
                              haveolddata: false,
                            )));
              },
              icon: const Icon(
                Icons.add,
                color: kdwhitecolor,
                size: 28,
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Obx(() => Column(
              children: [
                ListView.builder(
                    itemCount: logeduserctrl!.messagetemplates.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      MessageTemplates onedata =
                          logeduserctrl!.messagetemplates[index];
                      return buildonemessage(
                        context: context,
                        lable: onedata.lable,
                        onedata: onedata,
                        message: onedata.content,
                      );
                    })
              ],
            )),
      ),
    );
  }

  Widget buildonemessage({
    required context,
    required String lable,
    required String message,
    required MessageTemplates onedata,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessageTemplateMobile(
                      haveolddata: true,
                      predata: onedata,
                    )));
      },
      child: Card(
        elevation: 5,
        color: Get.theme.scaffoldBackgroundColor,
        shadowColor: Get.theme.colorScheme.primary,
        child: Container(
          // height: 70,
          padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
          margin: const EdgeInsets.only(bottom: 3),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    lable.text
                        .color(Get.theme.colorScheme.secondary)
                        .size(14)
                        .fontFamily('PoppinsSemiBold')
                        .overflow(TextOverflow.ellipsis)
                        .make(),
                    message.text
                        .color(Get.theme.colorScheme.primary)
                        .size(12)
                        .maxLines(2)
                        .fontFamily('PoppinsRegular')
                        .softWrap(true)
                        .overflow(TextOverflow.ellipsis)
                        .make(),
                    // const Divider(
                    //   thickness: 1,
                    //   color: kdaccentcolor,
                    //   height: 5,
                    // ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () async {
                    var result = await makeconfirmation(
                        context: context,
                        titel: "Confirmation !!!",
                        content: "Do you want to delete this template ?",
                        yestobutton: false);
                    if (result) {
                      deletetemplate(messageid: onedata.tableId);
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Get.theme.colorScheme.onSecondary,
                    size: 28,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
