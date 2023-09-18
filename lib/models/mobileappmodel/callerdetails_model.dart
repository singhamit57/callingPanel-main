import 'dart:convert';

UserWorkReport userWorkReportFromJson(String str) =>
    UserWorkReport.fromJson(json.decode(str));

class UserWorkReport {
  UserWorkReport({
    this.workingDays = '0',
    this.workingHrs = '0',
    this.workingMin = '0',
    this.avgWorking = '0',
    this.absents = '0',
    this.half = '0',
    this.shortLogin = '0',
    this.totalResponses = '0',
    this.usedLeads = '0',
    required this.departResponse,
    required this.responseCateg,
    required this.leadDetail,
    required this.openCloseLead,
    required this.successFailLead,
  });

  String? workingDays;
  String? workingHrs;
  String? workingMin;
  String? avgWorking;
  String? absents;
  String? half;
  String? shortLogin;
  String? totalResponses;
  String? usedLeads;
  List<String> departResponse;
  List<String> responseCateg;
  List<String> leadDetail;
  List<String> openCloseLead;
  List<String> successFailLead;

  factory UserWorkReport.fromJson(Map<String, dynamic> json) => UserWorkReport(
        workingDays: json["WorkingDays"],
        workingHrs: json["WorkingHrs"],
        workingMin: json["WorkingMin"],
        avgWorking: json["AvgWorking"],
        absents: json["Absents"],
        half: json["Half"],
        shortLogin: json["ShortLogin"],
        totalResponses: json["TotalResponses"],
        usedLeads: json["UsedLeads"],
        departResponse: List<String>.from(json["DepartResponse"].map((x) => x)),
        responseCateg: List<String>.from(json["ResponseCateg"].map((x) => x)),
        leadDetail: List<String>.from(json["LeadDetail"].map((x) => x)),
        openCloseLead: List<String>.from(json["OpenCloseLead"].map((x) => x)),
        successFailLead:
            List<String>.from(json["SuccessFailLead"].map((x) => x)),
      );
}
