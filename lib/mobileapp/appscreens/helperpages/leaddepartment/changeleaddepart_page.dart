import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mobileapp/appscreens/newdatapage/newdata_controll.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

MobileNewDataCtrl? mobileNewDataCtrl;

class LeadDepartsMobile extends StatefulWidget {
  const LeadDepartsMobile({Key? key}) : super(key: key);

  @override
  _LeadDepartsMobileState createState() => _LeadDepartsMobileState();
}

List<String> departlist = [];
var isloading = false.obs;

class _LeadDepartsMobileState extends State<LeadDepartsMobile> {
  getdepartlist() async {
    isloading.value = true;
    departlist.clear();
    String _url = mainurl + '/leaddatabase/uniquedepart_app.php';
    var body = {
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    http.Response response =
        await http.post(Uri.parse(_url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['Status'] == true) {
        departlist = List<String>.from(data['ResultData'].map((x) => x));
        setState(() {});
      } else {}
    }
    isloading.value = false;
  }

  @override
  void initState() {
    mobileNewDataCtrl = Get.find<MobileNewDataCtrl>();
    getdepartlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: "Department"
            .text
            .color(kdwhitecolor)
            .fontFamily('PoppinsSemiBold')
            .xl2
            .make(),
      ),
      body: Obx(() => SingleChildScrollView(
            child: isloading.value
                ? buildLinerloading()
                : Column(
                    children: [
                      Visibility(
                        visible: (departlist.isEmpty),
                        child: buildonerow(
                          lable: 'No Department Available',
                          context: context,
                        ),
                      ),
                      Visibility(
                        visible: (departlist.length > 1),
                        child: buildonerow(
                          lable: 'Any Department',
                          context: context,
                        ),
                      ),
                      ListView.builder(
                          itemCount: departlist.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return buildonerow(
                              lable: departlist[index],
                              context: context,
                            );
                          })
                    ],
                  ),
          )),
    );
  }

  Widget buildonerow({
    required String lable,
    required context,
  }) {
    return InkWell(
      onTap: () {
        if (lable == 'No Department Available') return;

        mobileNewDataCtrl!.selecteddepartment.value = lable;
        Navigator.pop(context, true);
        showsnackbar(
          titel: 'Success',
          detail: 'Department set to $lable successfully',
        );
      },
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(5, 0, 10, 5),
        child: lable.text
            .color(Get.theme.colorScheme.primary)
            .fontFamily('PoppinsRegular')
            .xl
            .make(),
      ),
    );
  }
}
