import 'package:flutter/material.dart';
import 'package:devlog_microblog_client/pages/main.dart';
import 'package:devlog_microblog_client/pages/post.dart';
import 'package:devlog_microblog_client/pages/settings.dart';
import 'package:devlog_microblog_client/pages/login.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(MicroblogApp());
}

class MicroblogApp extends StatelessWidget {
  const MicroblogApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Devlog Microblog Client',
        home: MainScreen(),
        routes: <String, WidgetBuilder>{
          '/post': (BuildContext context) => PostEditScreen(),
          '/settings': (BuildContext context) => SettingsScreen(),
          '/login': (BuildContext context) => LoginScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
      ),
    );
  }
}
