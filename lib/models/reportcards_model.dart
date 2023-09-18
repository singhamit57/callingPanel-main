// To parse this JSON data, do
//
//     final reportCardModel = reportCardModelFromJson(jsonString);

import 'dart:convert';

ReportCardModel reportCardModelFromJson(String str) =>
    ReportCardModel.fromJson(json.decode(str));

String reportCardModelToJson(ReportCardModel data) =>
    json.encode(data.toJson());

class ReportCardModel {
  ReportCardModel({
    this.totalLeads = '0',
    this.availableLeads = '0',
    this.dublicatieLeads = '0',
    this.usedLeads = '0',
    this.hotLeads = '0',
    this.mediumLeads = '0',
    this.coldLeads = '0',
    this.openLeads = '0',
    this.closedLeads = '0',
    this.successLeads = '0',
    this.failedLeads = '0',
    this.totalFollowups = '0',
    this.pendingFollowups = '0',
    this.todayFollowups = '0',
    this.callHistory = '0',
  });

  String totalLeads;
  String availableLeads;
  String dublicatieLeads;
  String usedLeads;
  String hotLeads;
  String mediumLeads;
  String coldLeads;
  String openLeads;
  String closedLeads;
  String successLeads;
  String failedLeads;
  String totalFollowups;
  String pendingFollowups;
  String todayFollowups;
  String callHistory;

  factory ReportCardModel.fromJson(Map<String, dynamic> json) =>
      ReportCardModel(
        totalLeads: json["TotalLeads"].toString(),
        availableLeads: json["AvailableLeads"].toString(),
        dublicatieLeads: json["DublicatieLeads"].toString(),
        usedLeads: json["UsedLeads"].toString(),
        hotLeads: json["HotLeads"].toString(),
        mediumLeads: json["MediumLeads"].toString(),
        coldLeads: json["ColdLeads"].toString(),
        openLeads: json["OpenLeads"].toString(),
        closedLeads: json["ClosedLeads"].toString(),
        successLeads: json["SuccessLeads"].toString(),
        failedLeads: json["FailedLeads"].toString(),
        totalFollowups: json["TotalFollowups"].toString(),
        pendingFollowups: json["PendingFollowups"].toString(),
        todayFollowups: json["TodayFollowups"].toString(),
        callHistory: json["CallHistory"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "TotalLeads": totalLeads,
        "AvailableLeads": availableLeads,
        "DublicatieLeads": dublicatieLeads,
        "UsedLeads": usedLeads,
        "HotLeads": hotLeads,
        "MediumLeads": mediumLeads,
        "ColdLeads": coldLeads,
        "OpenLeads": openLeads,
        "ClosedLeads": closedLeads,
        "SuccessLeads": successLeads,
        "FailedLeads": failedLeads,
        "TotalFollowups": totalFollowups,
        "PendingFollowups": pendingFollowups,
        "TodayFollowups": todayFollowups,
        "CallHistory": callHistory,
      };
}



/*

{
 "TotalLeads": "totalLeads",
  "AvailableLeads": "availableLeads",
  "DublicatieLeads":"DublicatieLeads",
  "UsedLeads":"UsedLeads",
  "TotalResponse": "totalResponse",
  "HotLeads": "hotLeads",
  "MediumLeads": "mediumLeads",
  "ColdLeads": "coldLeads",
  "OpenLeads":"OpenLeads",
  "ClosedLeads":"ClosedLeads",
  "SuccessLeads":"SuccessLeads",
  "FailedLeads":"asfdasfd",
  "TotalFollowups":"asfdasfd",
  "PendingFollowups":"asfdasfd",
  "TodayFollowups":"asfdasfd",
  "CallHistory":"asfdasfd"

}

*/