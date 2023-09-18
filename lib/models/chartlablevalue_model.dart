import 'package:fl_chart/fl_chart.dart';

class ChartLableValueModel {
  int gapCount;
  String lable;
  ChartLableValueModel({this.gapCount = 0, this.lable = ''});
}

class BarChartDataModel {
  int x;
  double y1;
  double y2;
  BarChartDataModel({this.x = 0, this.y1 = 0, this.y2 = 0});
}

class LineChartFullDataModel {
  List<ChartLableValueModel>? xaxislable;
  List<ChartLableValueModel>? yaxislable;
  List<FlSpot>? flspots;
  double? maxXcount;
  double? maxYcount;

  LineChartFullDataModel({
    this.xaxislable,
    this.yaxislable,
    this.flspots,
    this.maxXcount,
    this.maxYcount,
  });
}

class BarChartFullDataModel {
  final List<ChartLableValueModel>? xaxislable;
  final List<ChartLableValueModel>? yaxislable;

  final double? maxY;
  final List<BarChartDataModel>? barchartdataList;

  BarChartFullDataModel(
      {this.xaxislable, this.yaxislable, this.maxY, this.barchartdataList});
}
