import 'package:callingpanel/extensions/widget_ext.dart';
import 'package:flutter/material.dart';
import 'dashboard_controller.dart';
import 'dashhelper/dashbarchart_widget.dart';
import 'dashhelper/dashhelper_widget.dart';
import 'dashhelper/dashlinechart_widget.dart';
import 'dashhelper/dashpie_widget.dart';
import 'package:get/get.dart';

class DashBoardCharts extends StatefulWidget {
  const DashBoardCharts({Key? key}) : super(key: key);

  @override
  State<DashBoardCharts> createState() => _DashBoardChartsState();
}

DashBoardCtrl? dashBoardCtrl;
// ScrollController scrollController = ScrollController(initialScrollOffset: 2);

Key dashKey = const ValueKey('dashboradPageKey');

class _DashBoardChartsState extends State<DashBoardCharts> {
  ScrollController scrCtrl = ScrollController();
  List<Widget> charts = [];

  @override
  void initState() {
    dashBoardCtrl = Get.find<DashBoardCtrl>();
    dashBoardCtrl!.getdashboardData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    charts = [
      builadDailyCallLineChart(),
      buildbarchart(),
      buildUserRemainDataPieCahrt(),
      builadConvertLeadsLineChart(),
      builadSuccessLeadsLineChart(),
      buildAllResponsesPieCahrt(),
    ];

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.surface,
      body: Scrollbar(
        controller: scrCtrl,
        child: SingleChildScrollView(
          controller: scrCtrl,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: false,
                child: Row(
                  children: [
                    Expanded(
                      child: buildleftheadcard(),
                    ),
                    Expanded(child: buildcenterheadcard()),
                    Expanded(child: buildrightheadcard()),
                  ],
                ),
              ),
              Column(
                children: [
                  GridView.builder(
                    controller: ScrollController(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (context.isPhone)
                          ? 1
                          : (context.isSmallTablet && !context.isLargeTablet)
                              ? 2
                              : 3,
                    ),
                    shrinkWrap: true,
                    itemCount: charts.length,
                    itemBuilder: (context, index) {
                      return charts[index];
                    },
                  ),
                ],
              ).custumScrollBehaviour,
            ],
          ),
        ),
      ),
    );
  }

//Line Charts
  Widget builadDailyCallLineChart() {
    return Obx(() {
      final chartData = dashBoardCtrl!.dailycallLineChart.value;
      return LineChartSample2(
        key: const ValueKey('builadDailyCallLineChart'),
        flspots: chartData.flspots!,
        maxXcount: chartData.maxXcount!,
        maxYcount: chartData.maxYcount!,
        xaxislable: chartData.xaxislable!,
        yaxislable: chartData.yaxislable!,
        titel: 'Call Report',
      );
    });
  }

  Widget builadConvertLeadsLineChart() {
    return Obx(() {
      final chartData = dashBoardCtrl!.convertLeadsLineChart.value;
      return LineChartSample2(
        key: const ValueKey('builadConvertLeadsLineChart'),
        flspots: chartData.flspots!,
        maxXcount: chartData.maxXcount!,
        maxYcount: chartData.maxYcount!,
        xaxislable: chartData.xaxislable!,
        yaxislable: chartData.yaxislable!,
        titel: 'Convert Leads',
      );
    });
  }

  Widget builadSuccessLeadsLineChart() {
    return Obx(() {
      final chartData = dashBoardCtrl!.sucessLeadsLineChart.value;
      return LineChartSample2(
        key: const ValueKey('builadSuccessLeadsLineChart'),
        flspots: chartData.flspots!,
        maxXcount: chartData.maxXcount!,
        maxYcount: chartData.maxYcount!,
        xaxislable: chartData.xaxislable!,
        yaxislable: chartData.yaxislable!,
        titel: 'Success Leads',
      );
    });
  }

// Bar Charts
  Widget buildbarchart() {
    return Obx(() {
      final barchartData = dashBoardCtrl!.leasvsconvertleadDataBar.value;
      return BarChartSample2(
        key: const ValueKey('buildbarchart'),
        maxY: barchartData.maxY!,
        headTitel: 'Call Report',
        vers1: 'Total Lead',
        vers2: 'Convert Lead',
        yaxislable: barchartData.yaxislable!,
        xaxislable: barchartData.xaxislable!,
        barchartdataList: barchartData.barchartdataList!,
      );
    });
  }

  //Pie Charts
  Widget buildUserRemainDataPieCahrt() {
    return Obx(() {
      final piechartData = dashBoardCtrl!.usedRemainDataPie;
      return buildPieChart(
          piechartData, const ValueKey('buildUserRemainDataPieCahrt'));
    });
  }

  Widget buildAllResponsesPieCahrt() {
    return Obx(() {
      final piechartData = dashBoardCtrl!.allResponsesDataPie;
      return buildPieChart(
          piechartData, const ValueKey('buildAllResponsesPieCahrt'));
    });
  }
}

/*

 Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Expanded(child: builaddailycallLineChart()),
              Expanded(child: buildbarchart()),
              Expanded(child: buildPieChart(piedata)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: builaddailycallLineChart()),
              Expanded(child: buildbarchart()),
              Expanded(child: buildPieChart(piedata)),
            ],
          ),


Row(
      children: [
        const Expanded(child: PanelLeftPage()),
        Expanded(child: PanelCenterPage()),
        const Expanded(child: PanelRightPage()),
      ],
    );

*/
