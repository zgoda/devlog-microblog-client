import 'package:devlog_microblog_client/pages/home.dart';
import 'package:devlog_microblog_client/pages/login.dart';
import 'package:devlog_microblog_client/pages/edit_post.dart';
import 'package:devlog_microblog_client/pages/new_post.dart';
import 'package:devlog_microblog_client/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(child: MicroblogApp()),
  );
}

class MicroblogApp extends StatelessWidget {
  const MicroblogApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devlog Microblog Client',
      home: HomeScreen(),
      routes: <String, WidgetBuilder>{
        '/post/edit': (BuildContext context) => PostEditScreen(),
        '/post/new': (BuildContext context) => PostCreateScreen(),
        '/settings': (BuildContext context) => SettingsScreen(),
        '/login': (BuildContext context) => LoginScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
    );
  }
}
