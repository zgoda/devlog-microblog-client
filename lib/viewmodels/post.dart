import 'package:devlog_microblog_client/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postCollectionViewModelProvider =
    StateNotifierProvider<PostCollectionNotifier>(
        (ref) => PostCollectionNotifier());

class PostCollectionNotifier extends StateNotifier<List<Post>> {
  PostCollectionNotifier() : super([]);

  void add(Post post) => state = [post, ...state];

  void update(Post post) {
    final posts = [...state];
    posts.forEach((item) {
      if (item.pk == post.pk) {
        item = post;
      }
    });
    state = posts;
  }

  void addAll(List<Post> posts) => state = [...state, ...posts];

  List<Post> get posts => state;
}
