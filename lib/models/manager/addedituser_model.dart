import 'dart:convert';

NewUserModel newUserModelFromJson(String str) =>
    NewUserModel.fromJson(json.decode(str));
String newUserModelToJson(NewUserModel data) => json.encode(data.toJson());

List<NewUserModel> newUserlistModelFromJson(String str) =>
    List<NewUserModel>.from(
        json.decode(str).map((x) => NewUserModel.fromJson(x)));
String newUserModellistToJson(List<NewUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewUserModel {
  NewUserModel({
    this.logedUserId = '',
    this.logedUserName = '',
    this.isnewuser = '1',
    this.preTableId = '0',
    this.companyId = '',
    this.companyName = '',
    this.userId = '',
    this.fullName = '',
    this.userstatus = '',
    this.mobile = '',
    this.altMobile = '',
    this.email = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.pincode = '',
    this.bankName = '',
    this.accountNumber = '',
    this.ifsc = '',
    this.gender = '',
    this.password = '',
    this.datacode = '',
    this.imagePic = '',
    this.addressPic = '',
    this.designation = '',
    this.department = '',
    this.lastlogin = '',
    this.addEditDepartmetn = '0',
    this.addEditResponse = '0',
    this.addEditUser = '0',
    this.addEditLead = '0',
    this.deleteUpdateLead = '0',
    this.viewReports = '0',
    this.downloadReport = '0',
    this.updateReport = '0',
    this.makeCall = '0',
    this.sendSms = '0',
    this.sendMail = '0',
  });

  String logedUserId;
  String logedUserName;
  String isnewuser;
  String preTableId;
  String companyId;
  String companyName;
  String userId;
  String fullName;
  String userstatus;
  String mobile;
  String altMobile;
  String email;
  String country;
  String state;
  String city;
  String pincode;
  String bankName;
  String accountNumber;
  String ifsc;
  String gender;
  String password;
  String datacode;
  String imagePic;
  String addressPic;
  String department;
  String designation;
  String lastlogin;
  String addEditDepartmetn;
  String addEditResponse;
  String addEditUser;
  String addEditLead;
  String deleteUpdateLead;
  String viewReports;
  String downloadReport;
  String updateReport;
  String makeCall;
  String sendSms;
  String sendMail;

  factory NewUserModel.fromJson(Map<String, dynamic> json) => NewUserModel(
        logedUserId: json["LogedUserId"].toString(),
        logedUserName: json["LogedUserName"].toString(),
        isnewuser: json["Isnewuser"].toString(),
        preTableId: json["PreTableId"].toString(),
        companyId: json["CompanyID"].toString(),
        companyName: json["CompanyName"].toString(),
        userId: json["UserID"].toString(),
        fullName: json["FullName"].toString(),
        userstatus: json["UserStatus"].toString() == '1' ? 'Active' : 'Block',
        mobile: json["Mobile"].toString(),
        altMobile: json["AltMobile"].toString(),
        email: json["Email"].toString(),
        country: json["Country"].toString(),
        state: json["State"].toString(),
        city: json["City"].toString(),
        pincode: json["Pincode"].toString(),
        bankName: json["BankName"].toString(),
        accountNumber: json["AccountNumber"].toString(),
        ifsc: json["IFSC"].toString(),
        gender: json["Gender"].toString(),
        password: json["UserPassword"].toString(),
        datacode: json["DataCode"].toString(),
        imagePic: json["ImagePic"].toString(),
        addressPic: json["AddressPic"].toString(),
        designation: json["Designation"].toString(),
        department: json["Department"].toString(),
        lastlogin: json["LastLogin"].toString(),
        addEditDepartmetn: json["AddEditDepartmetn"].toString(),
        addEditResponse: json["AddEditResponse"].toString(),
        addEditUser: json["AddEditUser"].toString(),
        addEditLead: json["AddEditLead"].toString(),
        deleteUpdateLead: json["DeleteUpdateLead"].toString(),
        viewReports: json["ViewReports"].toString(),
        downloadReport: json["DownloadReport"].toString(),
        updateReport: json["UpdateReport"].toString(),
        makeCall: json["MakeCall"].toString(),
        sendSms: json["SendSms"].toString(),
        sendMail: json["SendMail"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "LogedUserId": logedUserId,
        "LogedUserName": logedUserName,
        "Isnewuser": isnewuser,
        "PreTableId": preTableId,
        "CompanyID": companyId,
        "CompanyName": companyName,
        "UserID": userId,
        "FullName": fullName,
        "UserStatus": userstatus,
        "Mobile": mobile,
        "AltMobile": altMobile,
        "Email": email,
        "Country": country,
        "State": state,
        "City": city,
        "Pincode": pincode,
        "BankName": bankName,
        "AccountNumber": accountNumber,
        "IFSC": ifsc,
        "Gender": gender,
        "Password": password,
        "DataCode": datacode,
        "ImagePic": imagePic,
        "AddressPic": addressPic,
        "Designation": designation,
        "Department": department,
        "LastLogin": lastlogin,
        "AddEditDepartmetn": addEditDepartmetn,
        "AddEditResponse": addEditResponse,
        "AddEditUser": addEditUser,
        "AddEditLead": addEditLead,
        "DeleteUpdateLead": deleteUpdateLead,
        "ViewReports": viewReports,
        "DownloadReport": downloadReport,
        "UpdateReport": updateReport,
        "MakeCall": makeCall,
        "SendSms": sendSms,
        "SendMail": sendMail,
      };
}
