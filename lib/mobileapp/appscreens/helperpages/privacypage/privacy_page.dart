// import 'dart:convert';

import 'package:callingpanel/extensions/box_storage_extenstion.dart';
import 'package:callingpanel/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webviewx/webviewx.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late WebViewXController webviewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: "".isPolicyAccepted ? AppBar() : null,
      body: Column(
        children: [
          WebViewX(
            height: Get.height - 40,
            width: Get.width,
            onWebViewCreated: (WebViewXController webViewController) {
              webviewController = webViewController;
              _loadHtmlFromAssets();
            },
          ).expand(),
          Center(
            child:
                ElevatedButton(onPressed: () {}, child: "Accepted".toTextWid()),
          ),
        ],
      ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText =
        await rootBundle.loadString('assets/icons/privacy_policy.html');
    webviewController.loadContent(fileText, SourceType.html, fromAssets: true);
  }
}
