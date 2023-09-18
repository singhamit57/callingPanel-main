import 'package:callingpanel/constants/connection_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

uploadFile(
    String filename, List<int> bytedata, String operation, String category,
    {String? uploadDocID}) async {
  Dio dio = Dio();
  String url = mainurl + "/uploadfiles/uploader.php";
  FormData data = FormData.fromMap({
    'file': MultipartFile.fromBytes(
      bytedata,
      filename: filename,
    ),
    'Operation': operation,
    "Category": category,
    "UploadDocID": uploadDocID ?? ""
  });

  dio.post(url, data: data, onSendProgress: (count, total) {
    debugPrint("$count : $total");
  }).then((value) {
    if (value.statusCode == 200) {
      var _body = value.data;
      debugPrint(_body.toString());
    }
  });
}
