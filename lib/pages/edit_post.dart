import 'package:devlog_microblog_client/models/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
        child: Html(data: post.text),
      ),
    );
  }
}
