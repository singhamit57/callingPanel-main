import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/functions/confirmation_dilogue.dart';
import 'package:callingpanel/mini_widgets.dart/editdelete_widget.dart';
import 'package:callingpanel/models/leads/leadfulldetail_model.dart';
import 'package:callingpanel/pages/leads/leadpage_controll.dart';
import 'package:callingpanel/pages/uploaddata/adddata_controller.dart';
import 'package:callingpanel/pages/uploaddata/uploaddata_model.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class BuildLeadOneCardWeb extends StatelessWidget {
  final LeadFullDetail onedata;
  final LogeduserControll logeduserControll;
  final bool ischecked;
  final bool ischeckenabled;

  final ValueChanged<bool?>? onselect;
  const BuildLeadOneCardWeb({
    Key? key,
    required this.onedata,
    required this.logeduserControll,
    this.onselect,
    this.ischeckenabled = false,
    this.ischecked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: kdfbblue,
      child: ExpansionTile(
        collapsedIconColor: Get.theme.colorScheme.onSecondary,
        title: buildonetitelrow(
          left: buildtelibodytext(
            value: '${onedata.fullName}',
            icon: Icons.person,
          ),
          right: buildtelibodytext(
              value: '${onedata.addStamp}', icon: Icons.calendar_today),
        ),
        leading: ischeckenabled
            ? Checkbox(
                value: ischecked,
                onChanged: onselect,
                checkColor: kdfbblue,
                fillColor:
                    MaterialStateProperty.resolveWith((states) => kdwhitecolor),
              )
            : null,
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildonetitelrow(
                left: buildtelibodytext(
                    value: '${onedata.email}', icon: Icons.mail),
                right: buildtelibodytext(
                    value: '${onedata.departments} ', icon: Icons.engineering)),
            buildonetitelrow(
              left: buildtelibodytext(
                  value:
                      '${onedata.country} > ${onedata.state} > ${onedata.city}',
                  icon: Icons.place),
              right: buildtelibodytext(
                  value: '${onedata.mobile}, ${onedata.altMobile}'
                      .replaceAll(", NA", ""),
                  icon: Icons.phone),
            ),
            Visibility(
              visible: logeduserControll.showcompoption.value,
              child: buildonetitelrow(
                  left: buildtelibodytext(
                      value: '${onedata.companyName} (${onedata.companyId})',
                      icon: Icons.apartment),
                  right: const SizedBox()),
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: "Full Details".text.color(kdwhitecolor).bold.xl.make(),
          ),
          Container(
            width: double.infinity,
            height: 220,
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Row(
              children: [
                ///Column 1
                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        builchildtext("Issued Date", "${onedata.issueStamp}"),
                        builchildtext("Issued To", "${onedata.issuedUser}"),
                        builchildtext(
                            "Call Duration ", "${onedata.lastCallDuration}"),
                        builchildtext("Response", "${onedata.lastResponse}"),
                        builchildtext("Priority", "${onedata.lastPriority}"),
                        builchildtext("Meeting Date", "${onedata.lastIntDate}"),
                        builchildtext("Result", "${onedata.lastLeadResult}"),
                        builchildtext("Remark", "${onedata.lastRemark}"),
                      ],
                    ),
                  ),
                ),

                ///Column3
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            builchildtext("Data Code", "${onedata.dataCode}"),
                            builchildtext(
                                "Repeat Count", "${onedata.cRepeateCount}"),
                            builchildtext("Added By", "${onedata.addedBy}"),
                          ],
                        ),
                      ),
                      const Spacer(),
                      buildeditdeletebtn(
                        context: context,
                        ondedit: () {
                          UploaddataModel _data = UploaddataModel(
                            tableid: onedata.tableId ?? '',
                            fullName: onedata.fullName ?? '',
                            emailId: onedata.email ?? '',
                            mobile: onedata.mobile ?? '',
                            altMobile: onedata.altMobile ?? '',
                            profile: onedata.profile ?? '',
                            country: onedata.country ?? '',
                            state: onedata.state ?? '',
                            city: onedata.city ?? '',
                            department: onedata.departments ?? '',
                          );

                          Get.find<AddDataControll>()
                              .onpageload(editdata: _data);
                          Get.find<WorkPageController>()
                              .setworkpage(PageSwitch.newlead);
                        },
                        ondelete: () async {
                          var result = await makeconfirmation(
                            context: context,
                            titel: 'Confirmation',
                            content: 'Do you want to delete this lead ?',
                            yestobutton: false,
                          );
                          if (result == true) {
                            Get.find<LeadPageCtrl>()
                                .deleteonelead(tableid: onedata.tableId);
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
  ) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: titel
              .text
              // .color(Get.theme.colorScheme.primary)
              .white
              .size(16)
              .letterSpacing(1.2)
              .maxLines(1)
              .make(),
        ),
        SizedBox(
          width: 10,
          child: ":"
              .text
              // .color(Get.theme.colorScheme.onSecondary)
              .white
              .size(16)
              .letterSpacing(1.8)
              .make(),
        ),
        value
            .text
            // .color(Get.theme.colorScheme.primary)
            .white
            .size(16)
            .letterSpacing(1.8)
            .overflow(TextOverflow.ellipsis)
            .make(),
      ],
    );
  }

  Widget buildtelibodytext(
      {required String value, required IconData icon, double? txtsize}) {
    return Row(
      children: [
        Icon(
          icon,
          // color: kdskyblue,
          size: 20,
        ),
        const SizedBox(
          width: 3,
        ),
        value.text
            .color(kdwhitecolor)
            .size(txtsize ?? 16)
            .letterSpacing(1.6)
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


