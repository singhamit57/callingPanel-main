import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/models/chartlablevalue_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class BarChartSample2 extends StatefulWidget {
  final List<ChartLableValueModel> xaxislable;
  final List<ChartLableValueModel> yaxislable;
  final String headTitel;
  final String vers1;
  final String vers2;
  final double maxY;
  final List<BarChartDataModel> barchartdataList;
  const BarChartSample2({
    Key? key,
    required this.xaxislable,
    required this.yaxislable,
    required this.headTitel,
    required this.vers1,
    required this.vers2,
    required this.maxY,
    required this.barchartdataList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

// List<ChartLableValueModel> xaxislable = [
//   ChartLableValueModel(gapCount: 1, lable: 'Mon'),
//   ChartLableValueModel(gapCount: 2, lable: 'Tue'),
//   ChartLableValueModel(gapCount: 3, lable: 'Wed'),
//   ChartLableValueModel(gapCount: 4, lable: 'Thu'),
//   ChartLableValueModel(gapCount: 5, lable: 'Fri'),
//   ChartLableValueModel(gapCount: 6, lable: 'Sat'),
// ];

// List<ChartLableValueModel> yaxislable = [
//   ChartLableValueModel(gapCount: 1, lable: '1 K'),
//   ChartLableValueModel(gapCount: 3, lable: '3 K'),
//   ChartLableValueModel(gapCount: 5, lable: '5 K'),
// ];

// List<BarChartDataModel> barchartdataList = [
//   BarChartDataModel(x: 0, y1: 5, y2: 12),
//   BarChartDataModel(x: 1, y1: 5, y2: 12),
//   BarChartDataModel(x: 2, y1: 5, y2: 12),
//   BarChartDataModel(x: 3, y1: 5, y2: 12),
//   BarChartDataModel(x: 4, y1: 5, y2: 12),
//   BarChartDataModel(x: 5, y1: 5, y2: 12),
// ];

class BarChartSample2State extends State<BarChartSample2> {
  // final Color leftBarColor = const Color(0xff53fdd7);
  // final Color rightBarColor = const Color(0xffff5182);
  final Color leftBarColor = Get.theme.colorScheme.onPrimary;
  final Color rightBarColor = Get.theme.colorScheme.onSecondary;
  final double width = 7;

  // int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxHeight: 380, minHeight: 200, maxWidth: 700),
      child: Padding(
        padding: const EdgeInsets.only(
            top: Constants.kdPadding,
            left: Constants.kdPadding / 2,
            right: Constants.kdPadding / 2),
        child: Card(
          color: Get.theme.colorScheme.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          //Color(0xff232d37), //const Color(0xff2c4260),),

          child: Padding(
            padding: const EdgeInsets.all(Constants.kdPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //makeTransactionsIcon(),
                    Text(
                      widget.headTitel,
                      style: TextStyle(
                          color: Get.theme.colorScheme.secondaryContainer,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    // Text(
                    //   r'$345,462',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Of ',
                      style: TextStyle(
                        color: Get.theme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.vers1,
                      style: TextStyle(
                          color: leftBarColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      ' And ',
                      style: TextStyle(
                        color: Get.theme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.vers2,
                      style: TextStyle(
                          color: rightBarColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 38,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 15, 10),
                    child: BarChart(
                      BarChartData(
                        maxY: widget.maxY,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => TextStyle(
                                color: Get.theme.colorScheme.secondaryContainer,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            margin: 20,
                            getTitles: (double value) {
                              int count = value.toInt();
                              int index = widget.xaxislable.indexWhere(
                                  (element) => element.gapCount == count);
                              if (index >= 0) {
                                return widget.xaxislable[index].lable;
                              } else {
                                return '';
                              }
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => TextStyle(
                                color: Get.theme.colorScheme.secondaryContainer,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            margin: 32,
                            reservedSize: 14,
                            getTitles: (value) {
                              int count = value.toInt();
                              int index = widget.yaxislable.indexWhere(
                                  (element) => element.gapCount == count);
                              if (index >= 0) {
                                return widget.yaxislable[index].lable;
                              } else {
                                return '';
                              }
                            },
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: widget.barchartdataList.map((item) {
                          return BarChartGroupData(
                              barsSpace: 4,
                              x: item.x,
                              barRods: [
                                BarChartRodData(
                                  y: item.y1,
                                  colors: [leftBarColor],
                                  width: width,
                                ),
                                BarChartRodData(
                                  y: item.y2,
                                  colors: [rightBarColor],
                                  width: width,
                                ),
                              ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // List<BarChartGroupData> makeGroupData() {
  //   return List.generate(barchartdataList.length, (index) => {
  //     return BarChartGroupData(barsSpace: 4, x: x, barRods: [
  //     BarChartRodData(
  //       y: y1,
  //       colors: [leftBarColor],
  //       width: width,
  //     ),
  //     BarChartRodData(
  //       y: y2,
  //       colors: [rightBarColor],
  //       width: width,
  //     ),
  //   ]);
  //   });

  // }
}


/**
 * 
 */
