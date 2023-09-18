import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/models/chartlablevalue_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineChartSample2 extends StatefulWidget {
  final List<ChartLableValueModel> xaxislable;
  final List<ChartLableValueModel> yaxislable;
  final List<FlSpot> flspots;
  final String titel;
  final double maxXcount;
  final double maxYcount;

  const LineChartSample2(
      {Key? key,
      required this.xaxislable,
      required this.yaxislable,
      required this.titel,
      required this.flspots,
      required this.maxXcount,
      required this.maxYcount})
      : super(key: key);

  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

// List<ChartLableValueModel>? xaxislable;

// List<ChartLableValueModel>? yaxislable;

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    // const Color(0xff23b6e6),
    // const Color(0xff02d39a),
    Get.theme.colorScheme.secondaryContainer,
    Get.theme.colorScheme.secondaryContainer.withOpacity(.7),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
            left: Constants.kdPadding / 2,
            top: Constants.kdPadding,
            bottom: Constants.kdPadding,
            right: Constants.kdPadding / 2),
        child: Card(
          color: Get.theme.colorScheme.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 50, right: 25, bottom: 10, left: 20),
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Text(
                  widget.titel,
                  style: TextStyle(
                      color: Get.theme.colorScheme.secondaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      minX: 0,
      maxX: widget.maxXcount,
      minY: 0,
      maxY: widget.maxYcount,
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => TextStyle(
              color: Get.theme.colorScheme.secondaryContainer,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          getTitles: (value) {
            int count = value.toInt();
            int index = widget.xaxislable
                .indexWhere((element) => element.gapCount == count);
            if (index >= 0) {
              return widget.xaxislable[index].lable;
            } else {
              return '';
            }
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
              color: Get.theme.colorScheme.secondaryContainer,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          getTitles: (value) {
            int count = value.toInt();
            int index = widget.yaxislable
                .indexWhere((element) => element.gapCount == count);
            if (index >= 0) {
              return widget.yaxislable[index].lable;
            } else {
              return '';
            }
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      lineBarsData: [
        LineChartBarData(
          spots: widget.flspots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          preventCurveOverShooting: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
