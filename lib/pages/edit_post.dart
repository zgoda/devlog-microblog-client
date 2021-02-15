import 'package:devlog_microblog_client/models/post.dart';
import 'package:devlog_microblog_client/services/post.dart';
import 'package:devlog_microblog_client/utils/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context).settings.arguments;
    final textController = useTextEditingController(text: post.text);
    final titleController = useTextEditingController(text: post.title);
    final authorController = useTextEditingController(text: post.author);
    final postService = useProvider(postCollectionServiceProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Post'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final newPost = Post.copyFrom(post);
              newPost.pk = post.pk;
              await postService.updatePost(newPost);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Aktualizacja posta została wysłana')),
              );
              Navigator.of(context).pop();
            },
            child: Text('Zapisz'),
            style: TextButton.styleFrom(
              primary: Theme.of(context).dialogBackgroundColor,
            ),
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
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Treść',
                hintText: 'Treść posta',
                contentPadding: DEFAULT_TEXTFIELD_INSETS,
              ),
            ),
            DEFAULT_FIELD_SPACER,
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tytuł',
                hintText: 'Tytuł posta (niekoniecznie)',
                contentPadding: DEFAULT_TEXTFIELD_INSETS,
              ),
            ),
            DEFAULT_FIELD_SPACER,
            TextField(
              controller: authorController,
              decoration: InputDecoration(
                labelText: 'Autor',
                hintText: 'Autor posta (niekoniecznie)',
                contentPadding: DEFAULT_TEXTFIELD_INSETS,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
