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

final credentialsProvider = Provider<Credentials>((ref) {
  final prefs = ref.watch(userPrefsProvider);
  return prefs.credentials;
});

final userPrefsProvider = StateNotifierProvider((ref) => UserPrefsNotifier());

class UserPrefsNotifier extends StateNotifier<UserSettingsModel> {
  UserPrefsNotifier() : super(UserSettingsModel.empty());

  void update(UserSettingsModel prefs) {
    state = prefs;
    prefs.save();
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

  set credentials(Credentials credentials) {
    final newModel = UserSettingsModel.copyFrom(state);
    newModel.setCredentials(credentials.name, credentials.password);
    state = newModel;
    newModel.save();
  }

  Credentials get credentials {
    return Credentials(name: state.username, password: state.password);
  }
}

final settingsProvider = FutureProvider<UserSettingsModel>((ref) async {
  final localStorageService = await LocalStorageService.create();
  final settings = localStorageService.settings;
  final prefsNotifier = ref.read(userPrefsProvider);
  prefsNotifier.update(settings);
  return settings;
});

class LocalStorageService {
  UserSettingsModel _settings;

  static Future<LocalStorageService> create() async {
    final instance = LocalStorageService();
    await instance._loadUserPrefs();
    return instance;
  }

  Future<void> _loadUserPrefs() async {
    _settings = await UserSettingsModel.load();
  }

  UserSettingsModel get settings {
    return _settings;
  }
}
