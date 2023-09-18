// To parse this JSON data, do
//
//     final uploaddataModel = uploaddataModelFromJson(jsonString);

import 'dart:convert';

List<UploaddataModel> uploaddataModelFromJson(String str) =>
    List<UploaddataModel>.from(
        json.decode(str).map((x) => UploaddataModel.fromJson(x)));

String uploaddataModelToJson(List<UploaddataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
String uploadonedataModelToJson(UploaddataModel data) =>
    json.encode(data.toJson());

class UploaddataModel {
  UploaddataModel({
    this.tableid = '',
    this.fullName = '',
    this.emailId = '',
    this.mobile = '',
    this.altMobile = '',
    this.profile = '',
    this.expirence = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.datacode = '',
    this.department = '',
    this.compId = '',
    this.compName = '',
    this.logedId = '',
    this.logedName = '',
  });

  String tableid;
  String fullName;
  String emailId;
  String mobile;
  String altMobile;
  String profile;
  String expirence;
  String country;
  String state;
  String city;
  String datacode;
  String department;
  String compId;
  String compName;
  String logedId;
  String logedName;

  factory UploaddataModel.fromJson(Map<String, dynamic> json) =>
      UploaddataModel(
        fullName: json["FullName"],
        emailId: json["EmailID"],
        mobile: json["Mobile"],
        altMobile: json["AltMobile"],
        profile: json["Profile"],
        expirence: json["Expirence"],
        country: json["Country"],
        state: json["State"],
        city: json["City"],
        department: json["Department"],
        compId: json["CompID"],
        compName: json["CompName"],
        logedId: json["LogedID"],
        logedName: json["LogedName"],
      );

  Map<String, dynamic> toJson() => {
        "TableId": tableid,
        "FullName": fullName,
        "EmailID": emailId,
        "Mobile": mobile,
        "AltMobile": altMobile,
        "Profile": profile,
        "Expirence": expirence,
        "Country": country,
        "State": state,
        "City": city,
        "Datacode": datacode,
        "Department": department,
        "CompID": compId,
        "CompName": compName,
        "LogedID": logedId,
        "LogedName": logedName,
      };
}

/*
{
  "FullName":"asdfads",
  "EmailID":"sffg",
  "Mobile":"sffgsfd",
  "AltMobile":"sdfgsfdg",
  "Profile":"sdfgsdfg",
  "Expirence":"sdfbsdfb",
  "Country":"sdfsdf",
  "State":"sdfbsf",
  "City":"dsfbsdf",
  "Department":"sdfasdf",
  "CompID":"sdfasdf",
  "CompName":"dsfdasfa",
  "LogedID":"dfadsfad",
  "LogedName":"dsafadsf" 

}

*/