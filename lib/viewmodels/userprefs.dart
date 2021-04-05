import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/userprefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userPrefsProvider = Provider<AppPrefs>((ref) {
  final prefs = ref.watch(userPrefsViewModelProvider);
  return prefs;
});

final userPrefsViewModelProvider =
    StateNotifierProvider<UserPrefsNotifier, AppPrefs>(
        (ref) => UserPrefsNotifier());

class UserPrefsNotifier extends StateNotifier<AppPrefs> {
  UserPrefsNotifier() : super(AppPrefs(host: ''));

  UserPrefsService _service;

  void init(UserPrefsService service) {
    _service = service;
    state = service.prefs;
  }

  AppPrefs get prefs => state;

  Future<void> updatePrefs(AppPrefs prefs) async {
    await _service.savePrefs(prefs);
    state = prefs;
  }
}
