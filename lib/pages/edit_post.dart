import 'package:devlog_microblog_client/models/post.dart';
import 'package:devlog_microblog_client/services/post.dart';
import 'package:devlog_microblog_client/utils/forms.dart';
import 'package:devlog_microblog_client/viewmodels/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostEditScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Post post = ModalRoute.of(context).settings.arguments;
    final titleController = useTextEditingController(text: post.title);
    final authorController = useTextEditingController(text: post.author);
    final postService = ref.watch(postServiceProvider);
    final postCollectionVM =
        ref.watch(postCollectionViewModelProvider.notifier);
    final textController = useTextEditingController(text: post.text);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final newPost = Post(
                text: textController.text.trim(),
                title: titleController.text.trim(),
                author: authorController.text.trim(),
                pk: post.pk,
              );
              final updatedPost = await postService.updatePost(newPost);
              if (updatedPost != null) {
                postCollectionVM.update(updatedPost);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Aktualizacja posta została wysłana')),
                );
              }
              Navigator.of(context).pop();
            },
            child: Text('Zapisz'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).dialogBackgroundColor,
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
