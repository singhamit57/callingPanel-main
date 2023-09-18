import 'dart:convert';

AllowedPermission allowedPermissionFromJson(String str) =>
    AllowedPermission.fromJson(json.decode(str));

class AllowedPermission {
  AllowedPermission({
    this.addEditDepartmetn = false,
    this.addEditResponse = false,
    this.addEditUser = false,
    this.addEditLead = false,
    this.deleteUpdateLead = false,
    this.viewReports = false,
    this.downloadReport = false,
    this.updateReport = false,
    this.makeCall = false,
    this.sendSms = false,
    this.sendMail = false,
  });

  bool addEditDepartmetn;
  bool addEditResponse;
  bool addEditUser;
  bool addEditLead;
  bool deleteUpdateLead;
  bool viewReports;
  bool downloadReport;
  bool updateReport;
  bool makeCall;
  bool sendSms;
  bool sendMail;

  factory AllowedPermission.fromJson(Map<String, dynamic> json) =>
      AllowedPermission(
          addEditDepartmetn: json["AddEditDepartmetn"] == '1',
          addEditResponse: json["AddEditResponse"] == '1',
          addEditUser: json["AddEditUser"] == '1',
          addEditLead: json["AddEditLead"] == '1',
          deleteUpdateLead: json["DeleteUpdateLead"] == '1',
          viewReports: json["ViewReports"] == '1',
          downloadReport: json["DownloadReport"] == '1',
          updateReport: json["UpdateReport"] == '1',
          makeCall: json["MakeCall"] == '1',
          sendSms: json["SendSms"] == '1',
          sendMail: json["SendMail"] == '1');
}
