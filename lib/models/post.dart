import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Post extends Equatable {
  final String title;
  final String text;
  final String author;
  final String textHtml;
  final DateTime created;
  final int pk;

  Post({
    @required this.text,
    this.title,
    this.author,
    this.textHtml,
    this.created,
    this.pk,
  });

  @override
  List<Object> get props => [pk, text, author, created];

  @override
  bool get stringify => true;

  factory Post.fromMap(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      text: json['text'],
      author: json['author'],
      textHtml: json['textHtml'],
      created: DateTime.parse(json['created']).toLocal(),
      pk: json['pk'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'text': text,
        'author': author,
      };
}
