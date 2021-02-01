import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsProvider = FutureProvider<UserSettingsModel>((ref) async {
  final localStorageService = await LocalStorageService.getInstance();
  return localStorageService.settings;
});

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
