import 'package:devlog_microblog_client/extensions.dart';
import 'package:devlog_microblog_client/models/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:devlog_microblog_client/servicelocator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator.allReady(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
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
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class MicroblogEntryList extends HookWidget {
  const MicroblogEntryList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postListModel = useProvider(postListProvider.state);
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemBuilder: (_, int index) =>
          MicroblogEntryItem(post: postListModel.posts[index]),
      itemCount: postListModel.posts.length,
    );
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
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  post.date.year.toString(),
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
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
