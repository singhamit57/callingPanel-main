import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/models/chartlablevalue_model.dart';
import 'package:callingpanel/models/piechartdata_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

LogeduserControll? logeduserControll;

class DashBoardCtrl extends GetxService {
  @override
  void onReady() {
    logeduserControll = Get.find<LogeduserControll>();
    super.onReady();
  }

  var productsold = '10'.obs;
  var totaluser = '10'.obs;
  var leadlength = '1256'.obs;
  int touchedIndex = -1;
  var dailycallLineChart = initialLineChart.obs;
  var convertLeadsLineChart = initialLineChart.obs;
  var sucessLeadsLineChart = initialLineChart.obs;
  var leasvsconvertleadDataBar = initialBarChart.obs;
  var usedRemainDataPie = <SetPieChartData>[].obs;
  var allResponsesDataPie = <SetPieChartData>[].obs;
  getdashboardData() async {
    String _url = mainurl + '/reports/dashboardreport.php';
    var body = {
      ...logeduserControll!.logedUserdetailMap(),
    };

    try {
      http.Response response =
          await http.post(Uri.parse(_url), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          setChartsData(data['ResultData']);
        }
      }
    } catch (e) {
      debugPrint("getdashboardData : $e");
    }
  }

  setChartsData(dynamic data) {
    dailycallLineChart.value = makelinechart(data['DailyCallLine']);
    convertLeadsLineChart.value = makelinechart(data['ConvertLeadsLine']);
    sucessLeadsLineChart.value = makelinechart(data['SuccessLeadsLine']);
    leasvsconvertleadDataBar.value = makebarchart(data['LeadVsConvertLeadBar']);
    usedRemainDataPie.value = makePieChart(data['UsedRemainPie']);
    allResponsesDataPie.value = makePieChart(data['AllResponsePiec']);
  }
}

LineChartFullDataModel makelinechart(dynamic chartname) {
  List<FlSpot> _spot = List<FlSpot>.from(chartname['flspots'].map((xy) =>
      FlSpot(
          double.parse(xy['x'].toString()), double.parse(xy['y'].toString()))));
  List<ChartLableValueModel> _xaxisdata = List<ChartLableValueModel>.from(
      chartname['xaxislable'].map((one) => ChartLableValueModel(
            gapCount: int.parse(one['gapCount'].toString()),
            lable: one['lable'].toString(),
          )));

  List<ChartLableValueModel> _yaxisdata = List<ChartLableValueModel>.from(
      chartname['yaxislable'].map((one) => ChartLableValueModel(
            gapCount: int.parse(one['gapCount'].toString()),
            lable: one['lable'].toString(),
          )));

  final linechartmake = LineChartFullDataModel(
    maxXcount: double.parse(chartname['maxXcount'].toString()),
    maxYcount: double.parse(chartname['maxYcount'].toString()),
    flspots: _spot,
    xaxislable: _xaxisdata,
    yaxislable: _yaxisdata,
  );
  return linechartmake;
}

BarChartFullDataModel makebarchart(dynamic chartname) {
  List<ChartLableValueModel> _xaxisdata = List<ChartLableValueModel>.from(
      chartname['xaxislable'].map((one) => ChartLableValueModel(
            gapCount: int.parse(one['gapCount'].toString()),
            lable: one['lable'],
          )));

  List<ChartLableValueModel> _yaxisdata = List<ChartLableValueModel>.from(
      chartname['yaxislable'].map((one) => ChartLableValueModel(
            gapCount: int.parse(one['gapCount'].toString()),
            lable: one['lable'],
          )));
  List<BarChartDataModel> _bardata = List<BarChartDataModel>.from(
      chartname['barchartdataList'].map((one) => BarChartDataModel(
            x: int.parse(one['x'].toString()),
            y1: double.parse(one['y1'].toString()),
            y2: double.parse(one['y2'].toString()),
          )));
  final barchartData = BarChartFullDataModel(
    maxY: double.parse(chartname['maxY'].toString()),
    xaxislable: _xaxisdata,
    yaxislable: _yaxisdata,
    barchartdataList: _bardata,
  );
  return barchartData;
}

List<SetPieChartData> makePieChart(dynamic chartname) {
  List<SetPieChartData> piedata =
      List<SetPieChartData>.from(chartname.map((one) {
    return SetPieChartData(
      titel: one['titel'],
      value: double.parse(one['value'].toString()),
      indicator: one['indicator'],
    );
  }));

  return piedata;
}

LineChartFullDataModel initialLineChart = LineChartFullDataModel(
  maxXcount: 7,
  maxYcount: 7,
  flspots: [], //FlSpot(x, y)
  xaxislable: [], //ChartLableValueModel(gapCount: ,lable: )
  yaxislable: [], //ChartLableValueModel(gapCount: ,lable: )
);

BarChartFullDataModel initialBarChart = BarChartFullDataModel(
  xaxislable: [
    ChartLableValueModel(gapCount: 0, lable: ''),
  ],
  yaxislable: [
    ChartLableValueModel(gapCount: 0, lable: ''),
  ],
  maxY: 15,
  barchartdataList: [
    BarChartDataModel(x: 0, y1: 0, y2: 0),
  ],
);
