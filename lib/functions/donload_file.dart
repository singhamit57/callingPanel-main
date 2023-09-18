import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import "package:universal_html/html.dart" as html;
import 'dart:io';
// import 'package:url_launcher/url_launcher.dart' as launch;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart' as launch;

downloadFileByUrl({
  required String url,
  bool? innewtab,
}) async {
  showsnackbar(titel: 'Please wait !', detail: 'Downloading in process...');
  String fileName = url.substring(url.lastIndexOf("/") + 1);
  fileName = fileName.replaceAll("_", "");
  try {
    if (!kIsWeb) {
      Dio dio = Dio();
      var dir = await getApplicationDocumentsDirectory();

      try {
        String fullpath = "${dir.path}/$fileName";
        final file = File(fullpath);
        var response = await dio.get(url,
            options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
                receiveTimeout: 0));
        final rufffile = file.openSync(mode: FileMode.write);
        rufffile.writeFromSync(response.data);
        await rufffile.close();
        showsnackbar(
            titel: "Sccuess !!!",
            detail: "File downloaded in \n${file.path.replaceAll("\\", "/")}.");
        // final canopen = await launch.canLaunch(file.path);

        launch.launchUrl(Uri.parse(file.path));
      } catch (e) {
        debugPrint("downloadFileByUrl : $e");
        showsnackbar(titel: "Failed !!!", detail: "Failed to download file...");
      }
    } else {
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = url;
      // anchorElement.target = "_blank";
      anchorElement.click();
    }
  } catch (e) {
    debugPrint("downloadbuttonclick : $e");
    showsnackbar(titel: 'Failed !!!', detail: 'Something is worng...');
  }
}
