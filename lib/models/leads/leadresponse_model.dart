// To parse this JSON data, do
//
//     final leadResponse = leadResponseFromJson(jsonString);

import 'dart:convert';

List<LeadResponse> leadResponseFromJson(String str) => List<LeadResponse>.from(
    json.decode(str).map((x) => LeadResponse.fromJson(x)));

String leadResponseToJson(List<LeadResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeadResponse {
  LeadResponse({
    this.tableId,
    this.companyId,
    this.leadId,
    this.userid,
    this.department,
    this.response,
    this.intDate,
    this.priority,
    this.leadResult,
    this.remark,
    this.callDuration,
    this.dataCode,
    this.respCount,
    this.lastUpdateStamp,
    this.lastUpdateBy,
    this.lastUpdateName,
    this.fullName,
    this.mobile,
    this.altMobile,
    this.email,
    this.showdate,
    this.showtime,
    this.showDuration,
    this.country,
    this.state,
    this.city,
    this.intdateshow,
    this.recordingid,
    this.recordingstatus = "Play Recording",
    this.downloadedpath = "",
  });

  String? tableId;
  String? companyId;
  String? leadId;
  String? userid;
  String? department;
  String? response;
  String? intDate;
  String? priority;
  String? leadResult;
  String? remark;
  String? callDuration;
  String? dataCode;
  String? respCount;
  String? lastUpdateStamp;
  String? lastUpdateBy;
  String? lastUpdateName;
  String? fullName;
  String? mobile;
  String? altMobile;
  String? email;
  String? showdate;
  String? showtime;
  String? showDuration;
  String? country;
  String? state;
  String? city;
  String? intdateshow;
  String? recordingid;
  String? recordingstatus;
  String? downloadedpath;

  factory LeadResponse.fromJson(Map<String, dynamic> json) => LeadResponse(
        tableId: json["Table_id"] ?? '',
        companyId: json["CompanyID"] ?? '',
        leadId: json["LeadID"] ?? '',
        userid: json["Userid"] ?? '',
        department: json["Department"] ?? '',
        response: json["Response"] ?? '',
        intDate: json["IntDate"],
        priority: json["Priority"] ?? '',
        leadResult: json["LeadResult"] ?? '',
        remark: json["Remark"] ?? '',
        callDuration: json["CallDuration"] ?? '',
        dataCode: json["DataCode"] ?? '',
        respCount: json["RespCount"] ?? '',
        lastUpdateStamp: json["LastUpdateStamp"],
        lastUpdateBy: json["LastUpdateBy"] ?? '',
        lastUpdateName: json["lastUpdateName"] ?? '',
        fullName: json["FullName"] ?? '',
        mobile: json["Mobile"] ?? '',
        altMobile: json["AltMobile"] ?? '',
        email: json["Email"] ?? '',
        showdate: json["Showdate"] ?? '',
        showtime: json["Showtime"] ?? '',
        showDuration: json["ShowDuration"] ?? '',
        country: json["Country"] ?? '',
        state: json["State"] ?? '',
        city: json["City"] ?? '',
        intdateshow: json["IntDateshow"] ?? '',
        recordingid: json["CallRecordID"] ?? '',
        recordingstatus: json["recordingstatus"] ?? 'Play Recording',
      );

  Map<String, dynamic> toJson() => {
        "Table_id": tableId,
        "CompanyID": companyId,
        "LeadID": leadId,
        "Userid": userid,
        "Department": department,
        "Response": response,
        "IntDate": intDate,
        "Priority": priority,
        "LeadResult": leadResult,
        "Remark": remark,
        "CallDuration": callDuration,
        "DataCode": dataCode,
        "RespCount": respCount,
        "LastUpdateStamp": lastUpdateStamp,
        "LastUpdateBy": lastUpdateBy,
        "FullName": fullName,
        "Mobile": mobile,
        "AltMobile": altMobile,
        "Email": email,
        "Showdate": showdate,
        "Showtime": showtime,
        "ShowDuration": showDuration,
      };
}
