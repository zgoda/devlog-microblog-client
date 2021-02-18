import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/utils/forms.dart';
import 'package:devlog_microblog_client/viewmodels/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = useProvider(credentialsViewModelProvider);
    final auth = useProvider(authenticationServiceProvider);
    final userNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final userNameField = TextField(
      autofocus: true,
      controller: userNameController,
      obscureText: false,
      decoration: InputDecoration(
        hintText: 'Nazwa użytkownika',
        contentPadding: DEFAULT_TEXTFIELD_INSETS,
      ),
    );
    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Hasło',
        contentPadding: DEFAULT_TEXTFIELD_INSETS,
      ),
    );
    final loginButton = Material(
      elevation: 5,
      color: Colors.blueGrey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: DEFAULT_TEXTFIELD_INSETS,
        onPressed: () async {
          prefs.updateCredentials(
            Credentials(
              name: userNameController.text,
              password: passwordController.text,
            ),
          );
          final loginResult = await auth.login();
          if (loginResult == AuthResult.ok) {
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
    return Scaffold(
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
                  DEFAULT_FIELD_SPACER,
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
  }
}
