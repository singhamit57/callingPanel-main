import 'dart:convert';

List<OneLeadCallLog> oneLeadCallLogFromJson(String str) =>
    List<OneLeadCallLog>.from(
        json.decode(str).map((x) => OneLeadCallLog.fromJson(x)));

String oneLeadCallLogToJson(List<OneLeadCallLog> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OneLeadCallLog {
  OneLeadCallLog({
    this.department,
    this.response,
    this.intdate,
    this.priority,
    this.leadresult,
    this.remark,
    this.callduration,
    this.updateby,
    this.updatebyName,
    this.showdate,
    this.showtime,
    this.showduration,
    this.recordingid,
  });

  String? department;
  String? response;
  String? intdate;
  String? priority;
  String? leadresult;
  String? remark;
  String? callduration;
  String? updateby;
  String? updatebyName;
  String? showdate;
  String? showtime;
  String? showduration;
  String? recordingid;

  factory OneLeadCallLog.fromJson(Map<String, dynamic> json) => OneLeadCallLog(
        department: json["department"] ?? '',
        response: json["response"] ?? '',
        intdate: json["intdate"] ?? '',
        priority: json["priority"] ?? '',
        leadresult: json["leadresult"] ?? '',
        remark: json["remark"] ?? '',
        callduration: json["callduration"] ?? '',
        updateby: json["updateby"] ?? '',
        updatebyName: json["updatebyname"] ?? '',
        showdate: json["showdate"] ?? '',
        showtime: json["showtime"] ?? '',
        showduration: json["showduration"] ?? '',
        recordingid: json["CallRecordID"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "department": department,
        "response": response,
        "intdate": intdate,
        "priority": priority,
        "leadresult": leadresult,
        "remark": remark,
        "callduration": callduration,
        "updateby": updateby,
        "showdate": showdate,
        "showtime": showtime,
        "showduration": showduration,
      };
}
