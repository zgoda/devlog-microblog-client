import 'package:flutter/material.dart';
import 'package:devlog_microblog_client/src/post_screen.dart';
import 'package:devlog_microblog_client/src/settings_screen.dart';

extension TruncateStringExtension on String {
  String truncateTo(int maxLength) =>
      (this.length <= maxLength) ? this : '${this.substring(0, maxLength)}...';
}

void main() {
  runApp(
    MicroblogApp(),
  );
}

class MicroblogApp extends StatelessWidget {
  const MicroblogApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devlog Microblog Client',
      home: MainScreen(),
      routes: <String, WidgetBuilder>{
        '/post': (BuildContext context) => PostEditScreen(),
        '/settings': (BuildContext context) => SettingsScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<MicroblogEntryItem> _entries = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showPostEntryScreen,
      ),
      appBar: AppBar(
        title: Text('Devlog Microblog Client'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        reverse: true,
        itemBuilder: (_, int index) => _entries[index],
        itemCount: _entries.length,
      ),
    );
  }

  void _openSettings() {
    Navigator.of(context).pushNamed('/settings');
  }

  void _showPostEntryScreen() {
    Navigator.of(context).pushNamed('/post');
  }
}

class MicroblogEntryItem extends StatelessWidget {
  MicroblogEntryItem({this.date, this.title, this.text});
  final String title;
  final String text;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dayStr = date.day.toString().padLeft(2, '0');
    final mthStr = date.month.toString().padLeft(2, '0');
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
                  date.year.toString(),
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(text.truncateTo(30)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
