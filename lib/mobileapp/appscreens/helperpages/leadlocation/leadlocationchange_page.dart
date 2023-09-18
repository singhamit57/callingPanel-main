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

import 'leadlocation_model.dart';

class LeadLocationsMobile extends StatefulWidget {
  final MobileNewDataCtrl? mobileNewDataCtrl;

  const LeadLocationsMobile({Key? key, this.mobileNewDataCtrl})
      : super(key: key);

  @override
  _LeadLocationsMobileState createState() => _LeadLocationsMobileState();
}

var leadlocations = <LeadLocations>[].obs;
var leadcountrys = <String>[].obs;
var leadstates = <String>[].obs;
var leadcities = <String>[].obs;
var isloading = false.obs;

class _LeadLocationsMobileState extends State<LeadLocationsMobile> {
  getlocationlist() async {
    leadlocations.clear();
    leadcountrys.clear();
    leadstates.clear();
    leadcities.clear();
    isloading.value = true;
    String _url = mainurl + '/leaddatabase/uniquelocation_app.php';
    var body = {
      "CompId": Get.find<LogeduserControll>().logeduserdetail.value.compId,
      ...Get.find<LogeduserControll>().logedUserdetailMap(),
    };
    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          leadlocations.value = List<LeadLocations>.from(
              data['ResultData'].map((x) => LeadLocations.fromJson(x)));
          for (var element in leadlocations) {
            if (element.country != null && element.country != 'NA') {
              if (!leadcountrys.contains(element.country)) {
                leadcountrys.add(element.country!);
              }
            }
            if (element.state != null && element.state != 'NA') {
              if (!leadstates.contains(element.state)) {
                leadstates.add(element.state!);
              }
            }
            if (element.city != null && element.city != 'NA') {
              if (!leadcities.contains(element.city)) {
                leadcities.add(element.city!);
              }
            }
          }
          isloading.value = false;
        } else {
          leadlocations.clear();
          isloading.value = false;
        }
      }
    } catch (e) {
      isloading.value = false;
    }
    isloading.value = false;
  }

  @override
  void initState() {
    getlocationlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: "Locations"
            .text
            .color(kdwhitecolor)
            .fontFamily('PoppinsSemiBold')
            .xl2
            .make(),
        // backgroundColor: Get.theme.primaryColorDark,
      ),
      body: Obx(() => SingleChildScrollView(
            child: isloading.value
                ? buildLinerloading()
                : Column(
                    children: [
                      Visibility(
                        visible: leadlocations.isEmpty,
                        child: buildonerow(
                          lable: 'No Location Available',
                          context: context,
                        ),
                      ),
                      Visibility(
                        visible: leadlocations.isNotEmpty,
                        child: InkWell(
                          onTap: () {
                            Get.find<MobileNewDataCtrl>()
                                .selectedlocation
                                .value = 'Any Location';
                            Get.find<MobileNewDataCtrl>().leadcountry = '';
                            Get.find<MobileNewDataCtrl>().leadstate = '';
                            Get.find<MobileNewDataCtrl>().leadcity = '';

                            setloctionresult(
                                context: context, lable: 'Any Location');
                          },
                          child: buildonerow(
                            lable: 'Any Location',
                            context: context,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: .8,
                        color: Get.theme.colorScheme.onSecondary,
                        height: 10,
                      ),

                      ///country generate
                      Visibility(
                        visible: leadcountrys.isNotEmpty,
                        child: Column(
                          children: [
                            buildonerow(
                              lable: 'Available Country',
                              islable: true,
                              context: context,
                            ),
                            ListView.builder(
                                itemCount: leadcountrys.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  String _country = leadcountrys[index];
                                  return InkWell(
                                    onTap: () {
                                      Get.find<MobileNewDataCtrl>()
                                          .selectedlocation
                                          .value = _country;
                                      Get.find<MobileNewDataCtrl>()
                                          .leadcountry = _country;
                                      Get.find<MobileNewDataCtrl>().leadstate =
                                          '';
                                      Get.find<MobileNewDataCtrl>().leadcity =
                                          '';

                                      setloctionresult(
                                          context: context, lable: _country);
                                    },
                                    child: buildonerow(
                                      lable: _country,
                                      context: context,
                                    ),
                                  );
                                }),
                            Divider(
                              thickness: .8,
                              color: Get.theme.colorScheme.onSecondary,
                              height: 10,
                            ),
                          ],
                        ),
                      ),

                      ///State generate
                      Visibility(
                        visible: leadstates.isNotEmpty,
                        child: Column(
                          children: [
                            buildonerow(
                              lable: 'Available States',
                              islable: true,
                              context: context,
                            ),
                            ListView.builder(
                                itemCount: leadstates.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  String _state = leadstates[index];
                                  return InkWell(
                                    onTap: () {
                                      Get.find<MobileNewDataCtrl>()
                                          .selectedlocation
                                          .value = _state;
                                      Get.find<MobileNewDataCtrl>()
                                          .leadcountry = '';
                                      Get.find<MobileNewDataCtrl>().leadstate =
                                          _state;
                                      Get.find<MobileNewDataCtrl>().leadcity =
                                          '';

                                      setloctionresult(
                                          context: context, lable: _state);
                                    },
                                    child: buildonerow(
                                      lable: _state,
                                      context: context,
                                    ),
                                  );
                                }),
                            Divider(
                              thickness: .8,
                              color: Get.theme.colorScheme.onSecondary,
                              height: 10,
                            ),
                          ],
                        ),
                      ),

                      ///City generate
                      Visibility(
                        visible: leadcities.isNotEmpty,
                        child: Column(
                          children: [
                            buildonerow(
                              lable: 'Available Cities',
                              islable: true,
                              context: context,
                            ),
                            ListView.builder(
                                itemCount: leadcities.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  String _city = leadcities[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Get.find<MobileNewDataCtrl>()
                                          .selectedlocation
                                          .value = _city;
                                      Get.find<MobileNewDataCtrl>()
                                          .leadcountry = '';
                                      Get.find<MobileNewDataCtrl>().leadstate =
                                          '';
                                      Get.find<MobileNewDataCtrl>().leadcity =
                                          _city;

                                      setloctionresult(
                                          context: context, lable: _city);
                                    },
                                    child: buildonerow(
                                      lable: _city,
                                      context: context,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }

  Widget buildonerow({
    required String lable,
    required context,
    bool? islable,
  }) {
    islable = islable ?? false;
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(5, 0, 10, 5),
      child: lable.text
          .color(islable
              ? Get.theme.colorScheme.secondary
              : Get.theme.colorScheme.primary)
          .fontFamily('PoppinsRegular')
          .xl
          .make(),
    );
  }
}

setloctionresult({required context, required String lable}) {
  Navigator.pop(context, true);
  showsnackbar(
      titel: 'Success',
      detail: 'Location set to $lable sucessfully',
      duration: 3);
}
