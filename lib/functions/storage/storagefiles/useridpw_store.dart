import 'package:callingpanel/functions/storage/storagekeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

savepassword({
  required String id,
  required String pw,
  String key = '',
}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (id.isNotEmpty) {
    preferences.setString(StorageKeys.userId, id);
  }
  if (pw.isNotEmpty) {
    preferences.setString(StorageKeys.userName, pw);
  }
  if (key.isNotEmpty) {
    preferences.setString(StorageKeys.userKey, pw);
  }
}

clearidpw() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString(StorageKeys.userId, '');
  preferences.setString(StorageKeys.userName, '');
}
