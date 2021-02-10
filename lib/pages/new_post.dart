import 'package:flutter/material.dart';

class PostCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Create new post'),
        actions: <Widget>[
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Saving post...'),
              ),
            ),
            child: Text('Save'),
            style: TextButton.styleFrom(primary: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text('New post'),
        ),
      ),
    );
  }
}
