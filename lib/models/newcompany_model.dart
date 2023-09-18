import 'dart:convert';

NewCompanyModel newCompanyModelFromJson(String str) =>
    NewCompanyModel.fromJson(json.decode(str));

String newCompanyModelToJson(NewCompanyModel data) =>
    json.encode(data.toJson());

class NewCompanyModel {
  NewCompanyModel({
    this.tableId = '',
    this.compId = '',
    this.compName = '',
    this.compEmail = '',
    this.compMobile = '',
    this.compAltMobile = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.maxResponses = '',
    this.maxDeparts = '',
    this.maxManagers = '',
    this.maxTelecallers = '',
    this.usedResponses = '',
    this.usedDeparts = '',
    this.usedManagers = '',
    this.usedTelecallers = '',
    this.compPrefix = '',
    this.activateDate = '',
    this.compStatus = '',
    this.smsEnable = '',
    this.mailEnable = '',
    this.addDate = '',
    this.addTime = '',
    this.lastUpdateBy = '',
    this.lastUpdateDate = '',
    this.lastUpdateTime = '',
  });
  String tableId;
  String compId;
  String compName;
  String compEmail;
  String compMobile;
  String compAltMobile;
  String country;
  String state;
  String city;
  String maxResponses;
  String maxDeparts;
  String maxManagers;
  String maxTelecallers;
  String usedResponses;
  String usedDeparts;
  String usedManagers;
  String usedTelecallers;
  String compPrefix;
  String activateDate;
  String compStatus;
  String smsEnable;
  String mailEnable;
  String addDate;
  String addTime;
  String lastUpdateBy;
  String lastUpdateDate;
  String lastUpdateTime;

  factory NewCompanyModel.fromJson(Map<String, dynamic> json) =>
      NewCompanyModel(
          tableId: json["TableId"] ?? '',
          compId: json["CompId"] ?? '',
          compName: json["CompName"] ?? '',
          compEmail: json["CompEmail"] ?? '',
          compMobile: json["CompMobile"] ?? '',
          compAltMobile: json["CompAltMobile"] ?? '',
          country: json["Country"] ?? '',
          state: json["State"] ?? '',
          city: json["City"] ?? '',
          maxResponses: json["MaxResponses"] ?? '',
          maxDeparts: json["MaxDeparts"] ?? '',
          maxManagers: json["MaxManagers"] ?? '',
          maxTelecallers: json["MaxTelecallers"] ?? '',
          usedResponses: json["UsedResponses"] ?? '',
          usedDeparts: json["UsedDeparts"] ?? '',
          usedManagers: json["UsedManagers"] ?? '',
          usedTelecallers: json["UsedTelecallers"] ?? '',
          compPrefix: json["CompPrefix"] ?? '',
          activateDate: json["ActivateDate"] ?? '',
          compStatus: json["CompStatus"] == '1' ? 'Active' : "Block",
          smsEnable: json["SmsEnable"] ?? '',
          mailEnable: json["MailEnable"] ?? '',
          addDate: json["AddDate"] ?? '',
          addTime: json["AddTime"] ?? '',
          lastUpdateBy: json["LastUpdateBy"] ?? '',
          lastUpdateDate: json["LastUpdateDate"] ?? '',
          lastUpdateTime: json["LastUpdateTime"] ?? '');

  Map<String, dynamic> toJson() => {
        "TableId": tableId,
        "CompId": compId,
        "CompName": compName,
        "CompEmail": compEmail,
        "CompMobile": compMobile,
        "CompAltMobile": compAltMobile,
        "Country": country,
        "State": state,
        "City": city,
        "MaxResponses": maxResponses,
        "MaxDeparts": maxDeparts,
        "MaxManagers": maxManagers,
        "MaxTelecallers": maxTelecallers,
        "CompPrefix": compPrefix,
        "ActivateDate": activateDate,
        "CompStatus": compStatus,
        "SmsEnable": smsEnable,
        "MailEnable": mailEnable,
        "AddDate": addDate,
        "AddTime": addTime,
        "LastUpdateBy": lastUpdateBy,
        "LastUpdateDate": lastUpdateDate,
        "LastUpdateTime": lastUpdateTime,
      };
}



/*

{
  "CompId":"adfads",
  "CompName":"asfsdaf",
  "CompEmail":"dafasdf",
  "CompMobile":"dafasdf",
  "CompAltMobile":"dafasdf",
  "Country":"dafasdf",
  "State":"dafasdf",
  "City":"dafasdf",
  "MaxResponses":"dafasdf",
  "MaxDeparts":"dafasdf",
  "MaxManagers":"dafasdf",
  "MaxTelecallers":"dafasdf",
  "CompPrefix":"dafasdf",
  "ActivateDate":"dafasdf",
  "CompStatus":"dafasdf",
  "SmsEnable":"dafasdf",
  "MailEnable":"dafasdf",
  "AddDate":"asfddasf",
  "AddTime":"asdfsadf",
  "LastUpdateBy":"adfdas",
  "LastUpdateDate":"asdfadf",
  "LastUpdateTime":"asdfads"
}

*/
