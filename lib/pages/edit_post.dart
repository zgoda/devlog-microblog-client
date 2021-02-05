import 'package:devlog_microblog_client/models/posts.dart';
import 'package:flutter/material.dart';

class PostEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Single post'),
      ),
      body: Center(
        child: Text(post.text),
      ),
    );
  }
}
