import 'package:callingpanel/functions/show_getsnack.dart';

showApiResultMsj({
  required dynamic apidata,
  String othermsj = 'Something is wrong...',
}) {
  String _resultmsj = "";
  if ((apidata.runtimeType != String)) {
    _resultmsj = (apidata['Msj'] ?? '').toString();
  }
  if (_resultmsj.isNotEmpty) {
    showsnackbar(titel: 'Message', detail: _resultmsj);
  } else {
    showsnackbar(titel: 'Message', detail: othermsj);
  }
}
