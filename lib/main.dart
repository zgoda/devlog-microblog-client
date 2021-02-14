import 'package:devlog_microblog_client/pages/home.dart';
import 'package:devlog_microblog_client/pages/loading.dart';
import 'package:devlog_microblog_client/pages/login.dart';
import 'package:devlog_microblog_client/pages/edit_post.dart';
import 'package:devlog_microblog_client/pages/new_post.dart';
import 'package:devlog_microblog_client/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(child: MicroblogApp()),
  );
}

class MicroblogApp extends StatelessWidget {
  const MicroblogApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microblog w Devlogu',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pl', ''),
      ],
      home: LoadingScreen(),
      routes: <String, WidgetBuilder>{
        '/post/edit': (BuildContext context) => PostEditScreen(),
        '/post/new': (BuildContext context) => PostCreateScreen(),
        '/settings': (BuildContext context) => SettingsScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/home': (BuildContext context) => HomeScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
    );
  }
}
