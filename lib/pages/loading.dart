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
    await AuthenticationService.getInstance(localStorage.settings);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            Navigator.of(context).pushNamed('/home');
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
