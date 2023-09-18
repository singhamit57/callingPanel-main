// LogedUserDetails logedUserDetailsFromJson(String str) => LogedUserDetails.fromJson();

class LogedUserDetails {
  String compId;
  String compName;
  String compMobile;
  String compAddress;
  String compEmail;
  String compWebsite;
  String compStatus;
  String logeduserId;
  String logeduserName;
  String logeduserDatacode;
  String logeduserMobile;
  String logeduserEmail;
  String logeduserPost;
  String loginKey;
  List<String>? logeduserDepartment;
  LogedUserDetails(
      {this.compId = '',
      this.compName = '',
      this.compStatus = '',
      this.logeduserId = '',
      this.logeduserName = '',
      this.logeduserDatacode = '',
      this.logeduserPost = '',
      this.compAddress = '',
      this.compEmail = '',
      this.compMobile = '',
      this.compWebsite = '',
      this.logeduserEmail = '',
      this.logeduserMobile = '',
      this.loginKey = '',
      this.logeduserDepartment});

  factory LogedUserDetails.fromJson(Map<String, dynamic> json) =>
      LogedUserDetails(
        compId: json["CompId"] ?? "",
        compName: json["CompName"] ?? "",
        compMobile: json["compMobile"] ?? "",
        compAddress: json["compAddress"] ?? "",
        compEmail: json["compEmail"] ?? "",
        compWebsite: json["compWebsite"] ?? "",
        compStatus: json["CompStatus"] ?? "",
        logeduserId: json["UserId"] ?? "",
        logeduserName: json["UserName"] ?? "",
        logeduserDatacode: json["DataCode"] ?? "",
        logeduserMobile: json["logeduserMobile"] ?? "",
        logeduserEmail: json["logeduserEmail"] ?? "",
        logeduserPost: json["UserDesignation"] ?? "",
        loginKey: json["LoginKey"] ?? "",
        logeduserDepartment:
            List<String>.from(json["UserDepartment"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'CompId': compId,
        'CompName': compId,
        'compMobile': compId,
        'compAddress': compId,
        'compEmail': compId,
        'compWebsite': compId,
        'CompStatus': compId,
        'UserId': compId,
        'UserName': compId,
        'DataCode': compId,
        'logeduserMobile': compId,
        'logeduserEmail': compId,
        'UserDesignation': compId,
        'LoginKey': compId,
      };
}
