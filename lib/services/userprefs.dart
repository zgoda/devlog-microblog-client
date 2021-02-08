import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userPreferencesProvider =
    StateNotifierProvider((ref) => UserPreferencesNotifier());

class UserPreferencesNotifier extends StateNotifier<UserSettingsModel> {
  UserPreferencesNotifier() : super(UserSettingsModel.empty()) {
    _init();
  }

  void _init() async {
    final storage = await LocalStorageService.getInstance();
    state = storage.settings;
  }

  UserSettingsModel getSettings() {
    return state;
  }

  void setCredentials(String name, String password) {
    final newPrefs = UserSettingsModel.copyFrom(state);
    newPrefs.setCredentials(name, password);
    state = newPrefs;
  }

  void setHost(String host) {
    final newPrefs = UserSettingsModel.copyFrom(state);
    newPrefs.host = host;
    state = newPrefs;
  }

  void setUnsecuredTransport(bool unsecuredTransport) {
    final newPrefs = UserSettingsModel.copyFrom(state);
    newPrefs.unsecuredTransport = unsecuredTransport;
    state = newPrefs;
  }
}
