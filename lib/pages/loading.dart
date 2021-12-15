import 'package:devlog_microblog_client/pages/appconfig.dart';
import 'package:devlog_microblog_client/pages/home.dart';
import 'package:devlog_microblog_client/pages/login.dart';
import 'package:devlog_microblog_client/viewmodels/appsettings.dart';
import 'package:devlog_microblog_client/viewmodels/credentials.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettingsInitialized = ref.watch(appSettingsInitializer);
    final credentialsVM = ref.watch(credentialsViewModelProvider);
    final userPrefsVM = ref.watch(userPrefsViewModelProvider);
    Widget result = Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
    appSettingsInitialized.whenData((_) {
      if (userPrefsVM.isConfigured) {
        if (!credentialsVM.isValid) {
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
