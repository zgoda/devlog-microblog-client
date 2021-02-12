import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/utils/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostCreateScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final defaultAuthor = useProvider(authorProvider);
    final textController = useTextEditingController();
    final titleController = useTextEditingController();
    final authorController = useTextEditingController(text: defaultAuthor);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Utwórz nowy post'),
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
                hintText: 'Treść',
                contentPadding: DEFAULT_TEXTFIELD_INSETS,
              ),
            ),
            DEFAULT_FIELD_SPACER,
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Tytuł (niekoniecznie)',
                contentPadding: DEFAULT_TEXTFIELD_INSETS,
              ),
            ),
            DEFAULT_FIELD_SPACER,
            TextField(
              controller: authorController,
              decoration: InputDecoration(
                hintText: 'Autor',
                contentPadding: DEFAULT_TEXTFIELD_INSETS,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
