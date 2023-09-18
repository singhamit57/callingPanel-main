import 'dart:convert';

UpdateHistoryModel updateHistoryModelFromJson(String str) =>
    UpdateHistoryModel.fromJson(json.decode(str));

String updateHistoryModelToJson(UpdateHistoryModel data) =>
    json.encode(data.toJson());

class UpdateHistoryModel {
  UpdateHistoryModel({
    this.companiesDetails = '0',
    this.departmentsDetails = '0',
    this.designationDetails = '0',
    this.followUpHistory = '0',
    this.leadResponse = '0',
    this.leadsDataBase = '0',
    this.loginDetails = '0',
    this.mailDetails = '0',
    this.messageTemplate = '0',
    this.permissionDetails = '0',
    this.responsesDetails = '0',
    this.smsDetails = '0',
    this.userDetails = '0',
  });

  String companiesDetails;
  String departmentsDetails;
  String designationDetails;
  String followUpHistory;
  String leadResponse;
  String leadsDataBase;
  String loginDetails;
  String mailDetails;
  String messageTemplate;
  String permissionDetails;
  String responsesDetails;
  String smsDetails;
  String userDetails;

  factory UpdateHistoryModel.fromJson(Map<String, dynamic> json) =>
      UpdateHistoryModel(
        companiesDetails: json["CompaniesDetails"],
        departmentsDetails: json["DepartmentsDetails"],
        designationDetails: json["DesignationDetails"],
        followUpHistory: json["FollowUpHistory"],
        leadResponse: json["LeadResponse"],
        leadsDataBase: json["LeadsDataBase"],
        loginDetails: json["LoginDetails"],
        mailDetails: json["MailDetails"],
        messageTemplate: json["MessageTemplate"],
        permissionDetails: json["PermissionDetails"],
        responsesDetails: json["ResponsesDetails"],
        smsDetails: json["SmsDetails"],
        userDetails: json["UserDetails"],
      );

  Map<String, dynamic> toJson() => {
        "CompaniesDetails": companiesDetails,
        "DepartmentsDetails": departmentsDetails,
        "DesignationDetails": designationDetails,
        "FollowUpHistory": followUpHistory,
        "LeadResponse": leadResponse,
        "LeadsDataBase": leadsDataBase,
        "LoginDetails": loginDetails,
        "MailDetails": mailDetails,
        "MessageTemplate": messageTemplate,
        "PermissionDetails": permissionDetails,
        "ResponsesDetails": responsesDetails,
        "SmsDetails": smsDetails,
        "UserDetails": userDetails,
      };
}
