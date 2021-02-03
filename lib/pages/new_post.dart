import 'package:flutter/material.dart';

class PostCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Create new post'),
      ),
      body: Center(
        child: Text('New post'),
      ),
    );
  }
}
