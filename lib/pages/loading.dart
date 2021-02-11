import 'package:devlog_microblog_client/pages/home.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userPrefsData = useProvider(settingsProvider);
    Widget result = Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
    userPrefsData.whenData((_) => result = HomeScreen());
    return result;
  }
}
