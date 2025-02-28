import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<String> saveImage(File imageFile) async {
    final imageBox = Hive.box('posts');

    // Read and compress image
    Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image decodedImage = img.decodeImage(imageBytes)!;
    img.Image compressedImage = img.copyResize(decodedImage, width: 800);
    Uint8List compressedBytes = Uint8List.fromList(img.encodeJpg(compressedImage, quality: 75));

    // Save compressed image locally
    Directory directory = await getApplicationDocumentsDirectory();
    String imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    File newImageFile = File(imagePath);
    await newImageFile.writeAsBytes(compressedBytes);

    // Store in Hive
    imageBox.put(imagePath, {'path': imagePath});

    return imagePath;
  }

  static List<String> getSavedImages() {
    final imageBox = Hive.box('posts');
    return imageBox.keys.cast<String>().toList();
  }
  static Future<void> toggleLike(String imagePath) async {
    final likesBox = Hive.box('likes');
    bool isLiked = likesBox.get(imagePath, defaultValue: false);
    likesBox.put(imagePath, !isLiked);
  }

  static bool isLiked(String imagePath) {
    final likesBox = Hive.box('likes');
    return likesBox.get(imagePath, defaultValue: false);
  }

  static Future<String> saveUserProfile(String username, String profilePicPath) async {
    final userBox = Hive.box('users');
    userBox.put('username', username);
    userBox.put('profilePic', profilePicPath);
    return username;
  }

  static String getUsername() {
    final userBox = Hive.box('users');
    return userBox.get('username', defaultValue: 'Guest');
  }

  static String getProfilePic() {
    final userBox = Hive.box('users');
    return userBox.get('profilePic', defaultValue: '');
  }
}
