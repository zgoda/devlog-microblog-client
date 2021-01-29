import 'package:devlog_microblog_client/models/userprefs.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static UserSettingsModel _settings;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_settings == null) {
      _settings = await UserSettingsModel.load();
    }
    return _instance;
  }

  UserSettingsModel get settings {
    return _settings;
  }
}
