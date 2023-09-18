import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

sendMail({required String email}) async {
  // Android and iOS
  if (GetUtils.isEmail(email)) {
    final uri = Uri.parse('mailto:$email?subject=Greetings&body=');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  } else {
    showsnackbar(titel: 'Alert !!!', detail: 'No valid email found...');
  }
}
