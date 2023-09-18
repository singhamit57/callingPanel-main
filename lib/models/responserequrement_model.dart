// To parse this JSON data, do
//
//     final responseRequrements = responseRequrementsFromJson(jsonString);

import 'dart:convert';

List<ResponseRequrements> responseRequrementsFromJson(String str) =>
    List<ResponseRequrements>.from(
        json.decode(str).map((x) => ResponseRequrements.fromJson(x)));

String responseRequrementsToJson(List<ResponseRequrements> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseRequrements {
  ResponseRequrements({
    this.response = '',
    this.tableid = '',
    this.needIntDate = false,
    this.needRemark = false,
    this.sendSms = false,
    this.sendMail = false,
  });

  String response;
  String tableid;
  bool needIntDate;
  bool needRemark;
  bool sendSms;
  bool sendMail;

  factory ResponseRequrements.fromJson(Map<String, dynamic> json) =>
      ResponseRequrements(
        response: json["Response"],
        tableid: json["TableId"],
        needIntDate: json["NeedIntDate"] == '1',
        needRemark: json["NeedRemark"] == '1',
        sendSms: json["SendSms"] == '1',
        sendMail: json["SendMail"] == '1',
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "TableId": tableid,
        "NeedIntDate": needIntDate ? '1' : '0',
        "NeedRemark": needRemark ? '1' : '0',
        "SendSms": sendSms ? '1' : '0',
        "SendMail": sendMail ? '1' : '0',
      };
}
