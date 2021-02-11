import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PostCreateScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final titleController = useTextEditingController();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textController,
              autofocus: true,
              maxLines: null,
              minLines: 8,
              decoration: InputDecoration(
                hintText: 'Post text',
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              ),
            ),
            SizedBox(height: 25),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Post title (optional)',
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
