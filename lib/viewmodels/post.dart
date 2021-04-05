import 'package:devlog_microblog_client/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postCollectionViewModelProvider =
    StateNotifierProvider<PostCollectionNotifier, List<Post>>(
        (ref) => PostCollectionNotifier());

class PostCollectionNotifier extends StateNotifier<List<Post>> {
  PostCollectionNotifier() : super([]);

  void add(Post post) => state = [post, ...state];

  void update(Post post) {
    final posts = state.map((e) {
      if (e.pk == post.pk) {
        return post;
      }
      return e;
    });
    state = posts.toList();
  }

  void addAll(List<Post> posts) => state = [...state, ...posts];

  List<Post> get posts => state;
}
