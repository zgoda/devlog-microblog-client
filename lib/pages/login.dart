import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final settingsData = useProvider(settingsProvider);
    final auth = useProvider(authenticationServiceProvider);
    final userNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    Widget result;
    settingsData.when(
      data: (settings) {
        final userNameField = TextField(
          autofocus: true,
          controller: userNameController,
          obscureText: false,
          decoration: InputDecoration(
            hintText: 'Nazwa użytkownika',
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          ),
        );
        final passwordField = TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Hasło',
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          ),
        );
        final loginButton = Material(
          elevation: 5,
          color: Colors.blueGrey,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            onPressed: () async {
              settings.setCredentials(
                  userNameController.text, passwordController.text);
              final loginResult = await auth.login();
              if (loginResult == AuthResult.ok) {
                settings.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Użytkownik zalogowany'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logowanie nieudane'),
                  ),
                );
              }
              Navigator.of(context).pop(loginResult);
            },
            child: Text('Zaloguj', textAlign: TextAlign.center),
          ),
        );
        result = Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Center(
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
          ),
        );
      },
      loading: () => result = Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => result = Center(
        child: Text(err),
      ),
    );
    return result;
  }
}
