import 'package:devlog_microblog_client/models/post.dart';
import 'package:devlog_microblog_client/services/post.dart';
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

class MicroblogEntryList extends HookConsumerWidget {
  Future<List<Post>> _fetchPostsPage(int curPage, PostService service) async {
    return await service.fetchCollection(page: curPage + 1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curPage = useState(0);
    final settingsVM = ref.watch(userPrefsViewModelProvider);
    final credentialsVM = ref.watch(credentialsViewModelProvider);
    final postService = ref.watch(postServiceProvider);
    final postCollectionVM = ref.watch(postCollectionViewModelProvider);
    final postCollection = ref.watch(postCollectionViewModelProvider);
    useMemoized(() async {
      if (settingsVM.isConfigured && credentialsVM.isValid) {
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
