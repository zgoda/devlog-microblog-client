import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hostProvider = Provider<String>((ref) {
  final prefs = ref.watch(userPrefsProvider);
  return prefs.host;
});

final secureTransportProvider = Provider<bool>((ref) {
  final prefs = ref.watch(userPrefsProvider);
  return prefs.secure;
});

final authorProvider = Provider<String>((ref) {
  final prefs = ref.watch(userPrefsProvider);
  return prefs.author;
});

final userPrefsProvider = StateNotifierProvider((ref) => UserPrefsNotifier());

class UserPrefsNotifier extends StateNotifier<UserSettingsModel> {
  UserPrefsNotifier() : super(UserSettingsModel.empty());

  void update(UserSettingsModel prefs) {
    state = prefs;
  }

  String get host {
    return state.host;
  }

  bool get secure {
    return !state.unsecuredTransport;
  }

  String get author {
    return state.defaultAuthor;
  }
}

final settingsProvider = FutureProvider<UserSettingsModel>((ref) async {
  final localStorageService = await LocalStorageService.getInstance();
  final settings = localStorageService.settings;
  final prefsNotifier = ref.read(userPrefsProvider);
  prefsNotifier.update(settings);
  return settings;
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
