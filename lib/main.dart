import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('Devlog Microblog Client'),
      ),
      body: MicroblogEntryList(),
    );
  }
}

class MicroblogEntryList extends StatefulWidget {
  @override
  _MicroblogEntryListState createState() => _MicroblogEntryListState();
}

class _MicroblogEntryListState extends State<MicroblogEntryList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <MicroblogEntryItem>[

        ],
      ),
    );
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
