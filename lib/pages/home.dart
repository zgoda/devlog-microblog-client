import 'package:devlog_microblog_client/extensions.dart';
import 'package:devlog_microblog_client/models/posts.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/services/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final settingsData = useProvider(settingsProvider);
    Widget result;
    settingsData.when(
      data: (settings) {
        if (!settings.isConfigured()) {
          Future.delayed(Duration.zero, () => _askForSettingsDialog(context));
        }
        result = Scaffold(
          resizeToAvoidBottomInset: true,
          floatingActionButton: FloatingActionButton(
            tooltip: 'Create new post',
            child: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed('/post'),
          ),
          appBar: AppBar(
            title: Text('Devlog Microblog Client'),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => Navigator.of(context).pushNamed('/settings'),
              ),
            ],
          ),
          body: MicroblogEntryList(),
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

  Future<void> _askForSettingsDialog(BuildContext ctx) async {
    var valueSelected = await showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Application not configured'),
        content: Text(
            'Application is not configured yet, do you want to open settings page?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
    if (valueSelected != null && valueSelected) {
      Navigator.of(ctx).pushNamed('/settings');
    }
  }
}

class MicroblogEntryItem extends StatelessWidget {
  final Post post;
  MicroblogEntryItem({this.post});

  @override
  Widget build(BuildContext context) {
    final dayStr = post.date.day.toString().padLeft(2, '0');
    final mthStr = post.date.month.toString().padLeft(2, '0');
    final dateFormatted = '$dayStr.$mthStr';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dateFormatted,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  post.date.year.toString(),
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title ?? '',
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(post.text.truncateTo(30)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MicroblogEntryList extends HookWidget {
  MicroblogEntryList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsData = useProvider(settingsProvider);
    final auth = useProvider(authenticationServiceProvider);
    final postService = useProvider(postCollectionServiceProvider);
    final postList = useProvider(postListProvider);
    final postListModel = useProvider(postListProvider.state);
    useMemoized(() {
      settingsData.whenData((settings) async {
        if (settings.isConfigured()) {
          if (settings.hasCredentials()) {
            await auth.login();
            final posts = await postService.fetchCollection();
            postList.addAll(posts);
          } else {
            final loginFormResult =
                await Navigator.of(context).pushNamed('/login');
            if (loginFormResult) {
              final posts = await postService.fetchCollection();
              postList.addAll(posts);
            }
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
