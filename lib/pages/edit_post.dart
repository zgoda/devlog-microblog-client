import 'package:devlog_microblog_client/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PostEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Post'),
        actions: <Widget>[
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Zapisywanie postu...'),
              ),
            ),
            child: Text('Zapisz'),
            style: TextButton.styleFrom(primary: Colors.white),
          ),
        ],
      ),
      body: Markdown(
        data: post.text,
      ),
    );
  }
}
