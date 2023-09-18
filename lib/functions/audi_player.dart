import 'dart:convert';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

var url =
    "https://sinoxfx.com/callcenter/uploadfiles/files/61601d847125c_agtel21085220211008154603674084recording.amr";
// playAudioFile() async {
//   print(("in"));
//   AudioPlayer audioPlayer = AudioPlayer();
//   int result = await audioPlayer.play(url);
//   print(("ok"));
//   print(result);
//   if (result == 1) {
//     // success
//   }
// }

// playAudioFile({
//   required String url,
// }) async {
//   // var duration = await player.setUrl(url);
//   try {
//     await player.setAudioSource(AudioSource.uri(Uri.parse(url)));
//     player.play();
//   } catch (e) {
//     debugPrint("Error loading audio source: $e");
//   }
//   // print(duration);
// }

Future<String> getaudiourlbyid({
  required String fileid,
}) async {
  String url = mainurl + "/uploadfiles/getfile.php";
  var body = {
    "id": fileid,
  };
  try {
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Status'] == true) {
        return data['ResultData']['fullFilepath'];
      } else {
        return "";
      }
    } else {
      return "";
    }
  } catch (e) {
    debugPrint("getaudiourlbyid : $e");
    return "";
  }
}
