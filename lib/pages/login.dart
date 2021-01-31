import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<UserSettingsModel> _future;
  UserSettingsModel _model;
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userNameField = TextField(
      controller: _userNameController,
      obscureText: false,
      decoration: InputDecoration(
        hintText: 'User name',
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
    );
    final passwordField = TextField(
      controller: _passwordController,
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
        onPressed: _loginButtonPressed,
        child: Text(
          'Login',
          textAlign: TextAlign.center,
        ),
      ),
    );
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _model = snapshot.data;
          return Center(
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
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _future = UserSettingsModel.load();
    super.initState();
  }

  void _loginButtonPressed() {
    _model.setCredentials(_userNameController.text, _passwordController.text);
    _model.save();
  }
}
