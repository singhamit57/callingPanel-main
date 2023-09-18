import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/models/oneleadhistory_model.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';

class CallHistoryCard extends StatelessWidget {
  final int index;
  final int totalcards;
  final OneLeadCallLog onedata;
  const CallHistoryCard({
    Key? key,
    required this.index,
    required this.totalcards,
    required this.onedata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.white,
        canvasColor: kdwhitecolor,
      ),
      child: TimelineTile(
        // nodeAlign: TimelineNodeAlign.start,
        // crossAxisExtent: 100,
        mainAxisExtent: 100,
        nodePosition: .2,
        oppositeContents: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (onedata.showdate ?? "").text.black.size(10).make(),
            (onedata.showtime ?? "").text.black.size(10).make(),
          ],
        ),
        node: TimelineNode(
          position: 1,
          direction: Axis.vertical,
          indicator: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), border: Border.all()),
          ),
          startConnector: index == 0
              ? null
              : const SolidLineConnector(
                  thickness: 1,
                  color: kdaccentcolor,
                ),
          endConnector: (index + 1) == totalcards
              ? null
              : const SolidLineConnector(
                  thickness: 1,
                  color: kdaccentcolor,
                ),
        ),
        contents: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(left: 10, bottom: 5, right: 10),
          decoration: BoxDecoration(
            color: kdblackcolor.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: "Department".historyText(),
                    ),
                    ": ".text.black.size(14).bold.make(),
                    Expanded(child: (onedata.department ?? "").historyText()),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: "Response".historyText(),
                    ),
                    ": ".text.black.size(14).bold.make(),
                    Expanded(child: (onedata.response ?? "").historyText()),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: "Remark".historyText(),
                    ),
                    ": ".text.black.size(14).bold.make(),
                    Expanded(child: (onedata.remark ?? "").historyText()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension HistoryCardText on String {
  Text historyText() {
    return Text(
      this,
      softWrap: true,
      maxLines: 3,
      style: const TextStyle(
        fontSize: 12,
        color: kdblackcolor,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
