import 'package:hive/hive.dart';
import '../models/post.dart';

class PostRepository {
  final Box<Post> _postBox = Hive.box<Post>('postsBox');

  void addPost(Post post) {
    _postBox.add(post);
  }

  List<Post> getAllPosts() {
    return _postBox.values.toList();
  }
}
