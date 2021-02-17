import 'package:devlog_microblog_client/pages/appconfig.dart';
import 'package:devlog_microblog_client/pages/home.dart';
import 'package:devlog_microblog_client/providers.dart';
import 'package:devlog_microblog_client/services/credentials.dart';
import 'package:devlog_microblog_client/services/userprefs.dart';
import 'package:devlog_microblog_client/viewmodels/credentials.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final securePrefs = useProvider(securePrefsProvider);
    final sharedPrefsData = useProvider(sharedPrefsProvider);
    final credentialsVM = useProvider(credentialsViewModelProvider);
    final userPrefsVM = useProvider(userPrefsViewModelProvider);
    Widget result = Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
    sharedPrefsData.whenData((sharedPrefs) {
      credentialsVM.init(CredentialsService(securePrefs));
      userPrefsVM.init(UserPrefsService(sharedPrefs));
      if (userPrefsVM.prefs.isConfigured) {
        result = HomeScreen();
      } else {
        result = AppConfigWizard();
      }
    });
    return result;
  }
}
