import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostListNotifier extends StateNotifier<PostListModel> {
  PostListNotifier() : super(_initialValue);

  static const _initialValue = PostListModel([]);

  void add(Post post) {
    state = PostListModel([...state.posts, post]);
  }

  void addAll(List<Post> posts) {
    state = PostListModel([...state.posts, ...posts]);
  }
}

final postListProvider = StateNotifierProvider((ref) => PostListNotifier());

class Post {
  String title;
  String text;
  DateTime date;
  int postId;

  Post({this.postId, this.title, this.text, this.date});

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
    date = DateTime.parse(json['created']);
    postId = json['pk'];
  }
}

class PostListModel {
  const PostListModel(this.posts);

  final List<Post> posts;
}
