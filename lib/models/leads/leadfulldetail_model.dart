// To parse this JSON data, do
//
//     final leadFullDetail = leadFullDetailFromJson(jsonString);

import 'dart:convert';

List<LeadFullDetail> leadFullDetailFromJson(String str) =>
    List<LeadFullDetail>.from(
        json.decode(str).map((x) => LeadFullDetail.fromJson(x)));

String leadFullDetailToJson(List<LeadFullDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeadFullDetail {
  LeadFullDetail({
    this.tableId = '',
    this.addStamp = '',
    this.companyId = '',
    this.addedBy = '',
    this.companyName = '',
    this.fullName = '',
    this.mobile = '',
    this.altMobile = '',
    this.email = '',
    this.profile = '',
    this.experience = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.departments = '',
    this.dataCode = '',
    this.gRepeateCount = '',
    this.cRepeateCount = '',
    this.issuedId = '',
    this.issueStamp = '',
    this.issuedUser = '',
    this.lastDepartment = '',
    this.lastResponse = '',
    this.lastIntDate = '',
    this.lastPriority = '',
    this.lastLeadResult = '',
    this.lastRemark = '',
    this.lastCallDuration = '',
    this.respStamp = '',
    this.respCount = '',
    this.lastUpdateBy = '',
    this.lastUpdateStamp = '',
    this.avtarpath = '',
  });

  String? tableId;
  String? addStamp;
  String? companyId;
  String? addedBy;
  String? companyName;
  String? fullName;
  String? mobile;
  String? altMobile;
  String? email;
  String? profile;
  String? experience;
  String? country;
  String? state;
  String? city;
  String? departments;
  String? dataCode;
  String? gRepeateCount;
  String? cRepeateCount;
  String? issuedId;
  String? issueStamp;
  String? issuedUser;
  String? lastDepartment;
  String? lastResponse;
  String? lastIntDate;
  String? lastPriority;
  String? lastLeadResult;
  String? lastRemark;
  String? lastCallDuration;
  String? respStamp;
  String? respCount;
  String? lastUpdateBy;
  String? lastUpdateStamp;
  String? avtarpath;

  factory LeadFullDetail.fromJson(Map<String, dynamic> json) => LeadFullDetail(
        tableId: json["Table_id"],
        addStamp: json["AddStamp"],
        companyId: json["CompanyID"],
        addedBy: json["AddedBy"],
        companyName: json["CompanyName"],
        fullName: json["FullName"],
        mobile: json["Mobile"],
        altMobile: json["AltMobile"],
        email: json["Email"],
        profile: json["Profile"],
        experience: json["Experience"],
        country: json["Country"],
        state: json["State"],
        city: json["City"],
        departments: json["Departments"],
        dataCode: json["DataCode"],
        gRepeateCount: json["GRepeateCount"],
        cRepeateCount: json["CRepeateCount"],
        issuedId: json["IssuedID"],
        issueStamp: json["IssueStamp"],
        issuedUser: json["IssuedUser"],
        lastDepartment: json["LastDepartment"],
        lastResponse: json["LastResponse"],
        lastIntDate: json["LastIntDate"],
        lastPriority: json["LastPriority"],
        lastLeadResult: json["LastLeadResult"],
        lastRemark: json["LastRemark"],
        lastCallDuration: json["LastCallDuration"],
        respStamp: json["RespStamp"],
        respCount: json["RespCount"],
        lastUpdateBy: json["LastUpdateBy"],
        lastUpdateStamp: json["LastUpdateStamp"],
        avtarpath: '',
      );

  Map<String, dynamic> toJson() => {
        "Table_id": tableId,
        "AddStamp": addStamp,
        "CompanyID": companyId,
        "AddedBy": addedBy,
        "CompanyName": companyName,
        "FullName": fullName,
        "Mobile": mobile,
        "AltMobile": altMobile,
        "Email": email,
        "Profile": profile,
        "Experience": experience,
        "Country": country,
        "State": state,
        "City": city,
        "Departments": departments,
        "DataCode": dataCode,
        "GRepeateCount": gRepeateCount,
        "CRepeateCount": cRepeateCount,
        "IssuedID": issuedId,
        "IssueStamp": issueStamp,
        "IssuedUser": issuedUser,
        "LastDepartment": lastDepartment,
        "LastResponse": lastResponse,
        "LastIntDate": lastIntDate,
        "LastPriority": lastPriority,
        "LastLeadResult": lastLeadResult,
        "LastRemark": lastRemark,
        "LastCallDuration": lastCallDuration,
        "RespStamp": respStamp,
        "RespCount": respCount,
        "LastUpdateBy": lastUpdateBy,
        "LastUpdateStamp": lastUpdateStamp,
      };
}
