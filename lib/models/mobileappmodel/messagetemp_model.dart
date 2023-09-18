// To parse this JSON data, do
//
//     final messageTemplates = messageTemplatesFromJson(jsonString);

import 'dart:convert';

List<MessageTemplates> messageTemplatesFromJson(String str) =>
    List<MessageTemplates>.from(
        json.decode(str).map((x) => MessageTemplates.fromJson(x)));

class MessageTemplates {
  MessageTemplates({
    this.tableId = '',
    this.showDate = '',
    this.showTime = '',
    this.lable = '',
    this.content = '',
  });

  String tableId;
  String showDate;
  String showTime;
  String lable;
  String content;

  factory MessageTemplates.fromJson(Map<String, dynamic> json) =>
      MessageTemplates(
        tableId: json["Table_Id"] ?? '',
        showDate: json["ShowDate"] ?? '',
        showTime: json["ShowTime"] ?? '',
        lable: json["Lable"] ?? '',
        content: json["Content"] ?? '',
      );
}
