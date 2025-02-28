import 'package:hive/hive.dart';

part 'post.g.dart'; // Run build_runner to generate this file

@HiveType(typeId: 0)
class Post {
  @HiveField(0)
  List<String> imagePaths; // Store multiple image paths

  @HiveField(1)
  String caption;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  int likes; // To track like count

  Post({
    required this.imagePaths,
    required this.caption,
    required this.timestamp,
    this.likes = 0,
  });
}
