import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userPreferencesProvider =
    StateNotifierProvider((ref) => UserPreferencesNotifier());

class UserPreferencesNotifier extends StateNotifier<UserSettingsModel> {
  UserPreferencesNotifier() : super(UserSettingsModel.empty()) {
    _init();
  }

  void _init() async {
    state = await UserSettingsModel.load();
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
}
