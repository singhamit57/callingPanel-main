import 'dart:convert';

List<OnlineUserDetailModel> onlineUserDetailModelFromJson(String str) =>
    List<OnlineUserDetailModel>.from(
        json.decode(str).map((x) => OnlineUserDetailModel.fromJson(x)));

String onlineUserDetailModelToJson(List<OnlineUserDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OnlineUserDetailModel {
  OnlineUserDetailModel({
    this.userId = '',
    this.isonlie = false,
    this.lastLogin = '',
  });

  String userId;
  bool isonlie;
  String lastLogin;

  factory OnlineUserDetailModel.fromJson(Map<String, dynamic> json) =>
      OnlineUserDetailModel(
        userId: json["UserID"],
        isonlie: json["Isonlie"],
        lastLogin: json["LastLogin"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "Isonlie": isonlie,
        "LastLogin": lastLogin,
      };
}




/*
[
  {
    "UserID":"afadsf",
    "Isonlie":true,
    "LastLogin":"adfadsfd"
  }
]

*/