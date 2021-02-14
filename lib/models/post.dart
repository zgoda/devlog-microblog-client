import 'package:flutter/foundation.dart';

class Post {
  String title;
  String text;
  String author;
  String textHtml;
  DateTime created;
  int pk;

  Post.createNew({@required String text, String author, String title}) {
    this.title = title;
    this.text = text;
    this.author = author;
  }

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
    author = json['author'];
    textHtml = json['textHtml'];
    created = DateTime.parse(json['created']).toLocal();
    pk = json['pk'];
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'text': text,
        'author': author,
      };
}
