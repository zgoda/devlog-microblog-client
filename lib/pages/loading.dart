import 'package:devlog_microblog_client/pages/appconfig.dart';
import 'package:devlog_microblog_client/pages/home.dart';
import 'package:devlog_microblog_client/pages/login.dart';
import 'package:devlog_microblog_client/viewmodels/appsettings.dart';
import 'package:devlog_microblog_client/viewmodels/credentials.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final appSettingsInitialized = useProvider(appSettingsInitializer);
    final credentialsVM = useProvider(credentialsViewModelProvider);
    final userPrefsVM = useProvider(userPrefsViewModelProvider);
    Widget result = Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
    appSettingsInitialized.whenData((_) {
      if (userPrefsVM.prefs.isConfigured) {
        if (!credentialsVM.credentials.isValid) {
          result = LoginScreen();
        } else {
          result = HomeScreen();
        }
      } else {
        result = AppConfigWizard();
      }
    });
    return result;
  }
}
