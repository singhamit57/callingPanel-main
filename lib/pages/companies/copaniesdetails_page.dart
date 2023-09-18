import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/extensions/widget_ext.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mini_widgets.dart/nodatafound_lottie.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'company_controller.dart';
import 'companycard.dart';

class AllCompniesDetailPage extends StatefulWidget {
  const AllCompniesDetailPage({Key? key}) : super(key: key);

  @override
  _AllCompniesDetailPageState createState() => _AllCompniesDetailPageState();
}

CompanyPageCtrl? addeditcompany;
LogeduserControll? logeduserctrl;

class _AllCompniesDetailPageState extends State<AllCompniesDetailPage> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    addeditcompany = Get.find<CompanyPageCtrl>();
    logeduserctrl = Get.find<LogeduserControll>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.find<Appbarcontroller>().newcompanyvisible.value = true;
      Get.find<Appbarcontroller>().searchvisible.value = true;
      addeditcompany!.showcompaniesList.value =
          addeditcompany!.allcompaniesList;
    });

    super.initState();
  }

  @override
  void dispose() {
    Get.find<Appbarcontroller>().newcompanyvisible.value = false;
    Get.find<Appbarcontroller>().searchvisible.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: (addeditcompany!.isloadingdata.value),
                  child: buildLinerloading()),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 25),
                  child: ("Companies Detail")
                      .text
                      .xl4
                      .color(Get.theme.colorScheme.onSecondary)
                      .fontFamily('PoppinsSemiBold')
                      .make()),
              Visibility(
                visible: (addeditcompany!.showcompaniesList.isEmpty &&
                    addeditcompany!.isloadingdata.value == false),
                child: buildnodatlottie(),
              ),
              Visibility(
                  visible: addeditcompany!.showcompaniesList.isNotEmpty,
                  child: Scrollbar(
                    controller: scrollController,
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: addeditcompany!.showcompaniesList.length,
                        itemBuilder: (context, index) {
                          return BuildCompanyCardWeb(
                            onedata: addeditcompany!.showcompaniesList[index],
                          );
                        }),
                  )),
            ],
          )),
    ).custumScrollBehaviour;
  }
}
