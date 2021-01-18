import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final userNameField = TextField(
      obscureText: false,
      decoration: InputDecoration(
        hintText: 'User name',
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
    );
    final passwordField = TextField(
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
    return Center(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 155),
              userNameField,
              SizedBox(height: 25),
              passwordField,
              SizedBox(height: 35),
              loginButton,
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void _loginButtonPressed() {}
}
