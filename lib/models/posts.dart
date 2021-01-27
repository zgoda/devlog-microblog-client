import 'package:hooks_riverpod/hooks_riverpod.dart';

class Post {
  String title;
  String text;
  DateTime date;
  int postId;

  Post({this.postId, this.title, this.text, this.date});

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
    date = json['created'];
    postId = json['pk'];
  }
}

class PostListModel {
  const PostListModel(this.posts);

  final List<Post> posts;
}
