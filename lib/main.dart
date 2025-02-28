import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:photo_sharing_app/data/models/post.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  await Hive.openBox<Post>('postsBox');
  await Hive.openBox('posts');
  await Hive.openBox('likes');
  await Hive.openBox('users');
  runApp(const PhotoSharingApp());
}
