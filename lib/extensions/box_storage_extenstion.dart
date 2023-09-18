import 'package:callingpanel/functions/storage/storagekeys.dart';
import 'package:get_storage/get_storage.dart';

final _box = GetStorage();

extension BoxStorageExt on String {
  bool get isPolicyAccepted {
    return _finder(StorageKeys.privacyAccepted) == "1";
  }

  String _finder(String key) {
    if (isNotEmpty) {
      if (this == "--") {
        _box.write(key, '');
      } else {
        _box.write(key, this);
      }
    }

    return _box.read<String>(key) ?? "";
  }
}
