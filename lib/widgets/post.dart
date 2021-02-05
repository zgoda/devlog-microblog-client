import 'package:devlog_microblog_client/models/posts.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/services/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MicroblogEntryItem extends StatelessWidget {
  final Post post;
  MicroblogEntryItem({this.post});

  @override
  Widget build(BuildContext context) {
    final dayStr = post.date.day.toString().padLeft(2, '0');
    final mthStr = post.date.month.toString().padLeft(2, '0');
    final dateFormatted = '$dayStr.$mthStr';
    final h6 = Theme.of(context).textTheme.headline6;
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dateFormatted,
                    style: h6,
                  ),
                  Text(
                    post.date.year.toString(),
                    style: h6,
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title ?? '',
                  style: h6,
                ),
                MarkdownBody(
                  data: post.text,
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () =>
          Navigator.of(context).pushNamed('/post/edit', arguments: post),
    );
  }
}

class MicroblogEntryList extends HookWidget {
  MicroblogEntryList({Key key}) : super(key: key);

  Future<int> _fetchPostsPage(int curPage, PostCollectionService service,
      PostListNotifier listModel) async {
    final page = curPage + 1;
    final posts = await service.fetchCollection(page: page);
    listModel.addAll(posts);
    if (posts.isNotEmpty) {
      return page;
    }
    return curPage;
  }

  @override
  Widget build(BuildContext context) {
    final curPage = useState(0);
    final settingsData = useProvider(settingsProvider);
    final auth = useProvider(authenticationServiceProvider);
    final postService = useProvider(postCollectionServiceProvider);
    final postList = useProvider(postListProvider);
    final postListModel = useProvider(postListProvider.state);
    useMemoized(() {
      settingsData.whenData((settings) async {
        if (settings.isConfigured()) {
          bool okResult;
          if (settings.hasCredentials()) {
            okResult = await auth.login() == AuthResult.ok;
          } else {
            okResult = await Navigator.of(context).pushNamed('/login');
          }
          if (okResult) {
            final newPage =
                await _fetchPostsPage(curPage.value, postService, postList);
            curPage.value = newPage;
          }
        }
      });
    });
    Widget result;
    settingsData.when(
      data: (settings) {
        result = ListView.builder(
          padding: EdgeInsets.all(8),
          itemBuilder: (_, int index) =>
              MicroblogEntryItem(post: postListModel.posts[index]),
          itemCount: postListModel.posts.length,
        );
      },
      loading: () => result = Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => result = Center(
        child: Text(err),
      ),
    );
    return result;
  }
}
