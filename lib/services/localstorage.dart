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

class UserPrefsNotifier extends StateNotifier<UserPrefs> {
  UserPrefsNotifier() : super(UserPrefs.empty());

  void update(UserPrefs prefs) {
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
    final newModel = UserPrefs.copyFrom(state);
    newModel.setCredentials(credentials: credentials);
    state = newModel;
    newModel.save();
  }

  Credentials get credentials {
    return Credentials(name: state.username, password: state.password);
  }
}

final settingsProvider = FutureProvider<UserPrefs>((ref) async {
  final localStorageService = await LocalStorageService.create();
  final settings = localStorageService.settings;
  final prefsNotifier = ref.watch(userPrefsProvider);
  prefsNotifier.update(settings);
  return settings;
});

class LocalStorageService {
  UserPrefs _settings;

  static Future<LocalStorageService> create() async {
    final instance = LocalStorageService();
    await instance._loadUserPrefs();
    return instance;
  }

  Future<void> _loadUserPrefs() async {
    _settings = await UserPrefs.load();
  }

  UserPrefs get settings {
    return _settings;
  }
}
