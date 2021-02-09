import 'package:hooks_riverpod/hooks_riverpod.dart';

class Post {
  String title;
  String text;
  String author;
  String textHtml;
  DateTime created;
  int pk;

  Post({
    this.pk,
    this.title,
    this.text,
    this.author,
    this.textHtml,
    this.created,
  });

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
    author = json['author'];
    textHtml = json['textHtml'];
    created = DateTime.parse(json['created']);
    pk = json['pk'];
  }
}

final postListProvider = StateNotifierProvider((ref) => PostListNotifier());

class PostListNotifier extends StateNotifier<List<Post>> {
  PostListNotifier() : super([]);

  void add(Post post) {
    state = [...state, post];
  }

  void addAll(List<Post> posts) {
    state = [...state, ...posts];
  }
}
