import 'package:callingpanel/functions/upload_file.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;

// Future<bool> startAudiRecord({
//   required String userid,
// }) async {
//   return false;
//   if (kIsWeb) return false;
//   String _path = (await getApplicationDocumentsDirectory()).path;
//   String filename = userid + DateTime.now().toString();
//   filename = filename
//       .replaceAll("-", "")
//       .replaceAll(" ", "")
//       .replaceAll(":", "")
//       .replaceAll(".", "");
//   _path = "$_path/$filename.m4a";
//   try {
//     if (await _audioRecorder.hasPermission()) {
//       await _audioRecorder.start(
//         path: _path,
//       );
//       bool isRecording = await _audioRecorder.isRecording();
//       return isRecording;
//     } else {
//       return false;
//     }
//   } catch (e) {
//     debugPrint("startAudiRecord : $e");
//     return false;
//   }
// }

// stopAudiRecord({
//   String? callRecordingID,
//   required bool uploadfile,
// }) async {
//   if (kIsWeb) return false;

//   // final path = await _audioRecorder.stop();
//   if (path != null && uploadfile) {
//     String filename = path.substring(path.lastIndexOf("/") + 1);
//     List<int> bytes = List.from(File(path).readAsBytesSync());
//     uploadFile(filename, bytes, "UploadCallAudio", "CallRecording",
//         uploadDocID: callRecordingID);
//   }
// }

Future<bool> pickaudiofile({
  String? callRecordingID,
  required bool uploadfile,
}) async {
  if (!uploadfile) return true;
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['mp3', 'amr', 'm4a']);

  if (result != null) {
    if (result.files.single.path == null) {
      String path = result.files.single.name;
      String extn = path.substring(path.lastIndexOf(".") + 1);
      var webbytes = result.files.first.bytes;
      uploadFile("$callRecordingID.$extn", List.from(webbytes!),
          "UploadCallAudio", "CallRecording",
          uploadDocID: callRecordingID);
    } else {
      String path = result.files.single.path!;
      String extn = path.substring(path.lastIndexOf(".") + 1);
      List<int> bytes = List.from(File(path).readAsBytesSync());
      uploadFile(
          "$callRecordingID.$extn", bytes, "UploadCallAudio", "CallRecording",
          uploadDocID: callRecordingID);
    }

    return true;
  } else {
    return false;
  }
}
