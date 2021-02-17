import 'package:devlog_microblog_client/widgets/misc.dart';
import 'package:devlog_microblog_client/widgets/post.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Utwórz nowy post',
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed('/post/new'),
      ),
      appBar: AppBar(
        title: Text('Microblog w Devlogu'),
        leading: ServerStatusIcon(),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: MicroblogEntryList(),
    );
  }
}
