import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/models/piechartdata_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard_controller.dart';

Widget buildPieChart(List<SetPieChartData> piechartdata, Key key) {
  ScrollController scrCtrl = ScrollController();
  return ConstrainedBox(
    key: key,
    constraints:
        const BoxConstraints(maxHeight: 380, minHeight: 200, maxWidth: 700),
    child: Padding(
      padding: const EdgeInsets.only(
          left: Constants.kdPadding / 2,
          bottom: Constants.kdPadding,
          right: Constants.kdPadding / 2),
      child: Card(
        color: Get.theme.colorScheme.background,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    sections: showingSections(piechartdata)),
                swapAnimationDuration: const Duration(seconds: 2),
              ),
            ),
            SizedBox(
              width: 140,
              child: Scrollbar(
                controller: scrCtrl,
                child: SingleChildScrollView(
                  controller: scrCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ...List.generate(
                        piechartdata.length,
                        (index) => Column(
                          children: [
                            Indicator(
                              color: cardcolors[index],
                              text: piechartdata[index].indicator!,
                              isSquare: true,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    ),
  );
}

List<PieChartSectionData> showingSections(List<SetPieChartData> piedata) {
  return List.generate(piedata.length, (i) {
    final isTouched = i == Get.find<DashBoardCtrl>().touchedIndex;
    final fontSize = isTouched ? 25.0 : 12.0;
    final radius = isTouched ? 60.0 : 60.0;

    return PieChartSectionData(
      color: cardcolors[i],
      value: piedata[i].value,
      title: piedata[i].titel,
      radius: radius,
      titleStyle: TextStyle(fontSize: fontSize, color: const Color(0xffffffff)),
    );
  });
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = Colors.white70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 12,
                color: Get.theme.colorScheme.secondaryContainer,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis),
          ),
        )
      ],
    );
  }
}
