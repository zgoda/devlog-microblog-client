import 'package:devlog_microblog_client/servicelocator.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginScreen extends HookWidget {
  final settings = locator<LocalStorageService>().settings;
  final auth = locator<AuthenticationService>();
  @override
  Widget build(BuildContext context) {
    final userNameController = useTextEditingController();
    final userNameField = TextField(
      controller: userNameController,
      obscureText: false,
      decoration: InputDecoration(
        hintText: 'User name',
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
    );
    final passwordController = useTextEditingController();
    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
    );
    final loginButton = Material(
      elevation: 5,
      color: Colors.blueGrey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          settings.setCredentials(
              userNameController.text, passwordController.text);
          auth.login().whenComplete(() {
            settings.save();
            Navigator.of(context).pop(true);
          });
        },
        child: Text(
          'Login',
          textAlign: TextAlign.center,
        ),
      ),
    );
    Future<void> future = locator.allReady();
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      userNameField,
                      SizedBox(height: 25),
                      passwordField,
                      SizedBox(height: 35),
                      loginButton,
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
