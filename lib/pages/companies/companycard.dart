import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/mini_widgets.dart/editdelete_widget.dart';
import 'package:callingpanel/models/newcompany_model.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'company_controller.dart';

class BuildCompanyCardWeb extends StatelessWidget {
  final NewCompanyModel onedata;
  const BuildCompanyCardWeb({Key? key, required this.onedata})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: kdfbblue,
      child: ExpansionTile(
        collapsedIconColor: Get.theme.colorScheme.onSecondary,
        title: buildonetitelrow(
            left: buildtelibodytext(
                value: onedata.compName, icon: Icons.person, txtsize: 20),
            right: buildtelibodytext(
                value: onedata.addDate, icon: Icons.calendar_today)),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildonetitelrow(
                left: buildtelibodytext(
                    value: onedata.compEmail, icon: Icons.mail),
                right: buildtelibodytext(
                    value: '${onedata.compId} ', icon: Icons.badge)),
            buildonetitelrow(
                left: buildtelibodytext(
                    value:
                        '${onedata.country} > ${onedata.state} > ${onedata.city}',
                    icon: Icons.place),
                right: buildtelibodytext(
                    value: '${onedata.compMobile}, ${onedata.compAltMobile}',
                    icon: Icons.phone)),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: "Full Details".text.color(kdwhitecolor).xl.make(),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Row(
              children: [
                ///Column 1
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        builchildtext("Prefix", onedata.compPrefix, false),
                        builchildtext(
                            "Responses Limit",
                            "${onedata.usedResponses} / ${onedata.maxResponses}",
                            false),
                        builchildtext(
                            "Departments Limit",
                            "${onedata.usedDeparts} / ${onedata.maxDeparts}",
                            false),
                        builchildtext(
                            "Managers Limit",
                            "${onedata.usedManagers} / ${onedata.maxManagers}",
                            false),
                        builchildtext(
                            "Telecallers Limit",
                            "${onedata.usedTelecallers} / ${onedata.maxTelecallers}",
                            false),
                      ],
                    ),
                  ),
                ),

                ///Column3
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            builchildtext(
                                "Update By", onedata.lastUpdateBy, true),
                            builchildtext(
                                "Update Date", onedata.lastUpdateDate, true),
                            builchildtext(
                                "Update Time", onedata.lastUpdateTime, true),
                          ],
                        ),
                      ),
                      const Spacer(),
                      buildeditdeletebtn(
                        context: context,
                        ondedit: () {
                          Get.find<CompanyPageCtrl>()
                              .onPageOpen(editdata: onedata);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             AddEditCompanyPage()));
                          Get.find<WorkPageController>()
                              .setworkpage(PageSwitch.addeditcompanies);
                        },
                        ondelete: () async {
                          var result = await makeconfirmation(
                            context: context,
                            titel: 'Confirmation',
                            content: 'Do you want to delete this company ?',
                            yestobutton: false,
                          );
                          if (result == true) {
                            Get.find<CompanyPageCtrl>()
                                .deleteonecompany(tableid: onedata.tableId);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildonetitelrow({
    required Widget left,
    required Widget right,
  }) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: left),
        Expanded(
          flex: 3,
          child: right,
        )
      ],
    );
  }

  Widget builchildtext(
    String titel,
    String value,
    bool isright,
  ) {
    return Row(
      children: [
        SizedBox(
          width: isright ? 130 : 180,
          child:
              titel.text.color(kdwhitecolor).size(16).letterSpacing(1.8).make(),
        ),
        SizedBox(
          width: 10,
          child: ":"
              .text
              .color(kdwhitecolor)
              .size(16)
              .fontFamily('PoppinsSemiBold')
              .letterSpacing(1.8)
              .make(),
        ),
        value.text.color(kdwhitecolor).size(16).letterSpacing(1.8).make(),
      ],
    );
  }

  Widget buildtelibodytext({
    required String value,
    required IconData icon,
    Color? textcolor,
    Color? iconcolor,
    double? txtsize,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconcolor,
          size: 20,
        ),
        const SizedBox(
          width: 3,
        ),
        value.text
            .color(textcolor ?? kdwhitecolor)
            .size(txtsize ?? 15)
            .letterSpacing(1)
            .fontFamily('PoppinsSemiBold')
            .softWrap(true)
            .align(TextAlign.left)
            .overflow(TextOverflow.fade)
            .make()
      ],
    );
  }
}

// Widget buildleadcard({
//   required context,
//   // required int index,
//   required LeadFullDetail onedata,
// }) {
//   return ;
// }


