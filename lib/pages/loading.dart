import 'package:devlog_microblog_client/pages/home.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future _future;

  @override
  void initState() {
    super.initState();
    _future = _init();
  }

  Future<bool> _init() async {
    final localStorage = await LocalStorageService.getInstance();
    print('loaded settings');
    await AuthenticationService.getInstance(localStorage.settings);
    print('loaded auth');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return HomeScreen();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
