import 'package:devlog_microblog_client/models/post.dart';
import 'package:devlog_microblog_client/services/post.dart';
import 'package:devlog_microblog_client/utils/forms.dart';
import 'package:devlog_microblog_client/viewmodels/credentials.dart';
import 'package:devlog_microblog_client/viewmodels/post.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostMetaInfo extends StatelessWidget {
  final DateTime date;
  PostMetaInfo({this.date});

  @override
  Widget build(BuildContext context) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final h6 = Theme.of(context).textTheme.headline6;
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$day.$month', style: h6),
          SizedBox(height: 4),
          Text(year, style: h6)
        ],
      ),
    );
  }
}

class PostTextInfo extends StatelessWidget {
  final String text;
  final String title;
  PostTextInfo({this.text, this.title});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    if (![null, ''].contains(title)) {
      children.add(Text(title, style: Theme.of(context).textTheme.headline6));
    }
    children.addAll([
      SizedBox(height: 6),
      MarkdownBody(data: text),
    ]);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class PostTextEditor extends HookWidget {
  final String _text;

  PostTextEditor({String text, Key key})
      : _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final textController = useTextEditingController(text: _text);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        SizedBox(
          height: 64,
          child: Scrollbar(
            controller: scrollController,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.format_bold),
                  onPressed: () => _toggleSelectionFormat('**', '**'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _toggleSelectionFormat(String left, String right) {}
}

class MicroblogEntryItem extends StatelessWidget {
  final Post post;
  MicroblogEntryItem({this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PostMetaInfo(date: post.created),
            PostTextInfo(text: post.text, title: post.title),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        '/post/edit',
        arguments: post,
      ),
    );
  }
}

class MicroblogEntryList extends HookWidget {
  Future<List<Post>> _fetchPostsPage(int curPage, PostService service) async {
    return await service.fetchCollection(page: curPage + 1);
  }

  @override
  Widget build(BuildContext context) {
    final curPage = useState(0);
    final settingsVM = useProvider(userPrefsViewModelProvider);
    final credentialsVM = useProvider(credentialsViewModelProvider);
    final postService = useProvider(postServiceProvider);
    final postCollectionVM = useProvider(postCollectionViewModelProvider);
    final postCollection = useProvider(postCollectionViewModelProvider.state);
    useMemoized(() async {
      if (settingsVM.prefs.isConfigured && credentialsVM.credentials.isValid) {
        final posts = await _fetchPostsPage(curPage.value, postService);
        if (posts.isNotEmpty) {
          postCollectionVM.addAll(posts);
          curPage.value += 1;
        }
      }
    });
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemBuilder: (_, int index) => MicroblogEntryItem(
        post: postCollection[index],
      ),
      itemCount: postCollection.length,
    );
  }
}
