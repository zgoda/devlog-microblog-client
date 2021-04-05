import 'package:devlog_microblog_client/providers.dart';
import 'package:devlog_microblog_client/services/credentials.dart';
import 'package:devlog_microblog_client/services/userprefs.dart';
import 'package:devlog_microblog_client/viewmodels/credentials.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appSettingsInitializer = FutureProvider<bool>((ref) async {
  final sharedPrefs = await ref.read(sharedPrefsProvider.future);
  final securePrefs = ref.read(securePrefsProvider);
  final userPrefsVMNotifier = ref.read(userPrefsViewModelProvider.notifier);
  final credentialsVMNotifier = ref.read(credentialsViewModelProvider.notifier);
  userPrefsVMNotifier.init(UserPrefsService(sharedPrefs));
  await credentialsVMNotifier.init(CredentialsService(securePrefs));
  return true;
});
