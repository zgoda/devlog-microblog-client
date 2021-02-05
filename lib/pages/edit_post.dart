import 'package:devlog_microblog_client/models/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
        child: Markdown(
          data: post.text,
        ),
      ),
    );
  }
}
