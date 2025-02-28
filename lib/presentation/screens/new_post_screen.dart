import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_filter_pro/named_color_filter.dart';
import 'package:image_filter_pro/photo_filter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_sharing_app/data/models/post.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  List<File> selectedImages = [];
  final TextEditingController captionController = TextEditingController();

  void _showImagePicker() async {
    final pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages.isNotEmpty) {
      List<File> tempImages = [];

      for (var pickedImage in pickedImages) {
        File imageFile = File(pickedImage.path);
        var updatedImage = await _applyFilter(imageFile);

        if (updatedImage != null) {
          tempImages.add(updatedImage);
        } else {
          tempImages.add(imageFile);
        }
      }

      setState(() {
        selectedImages.addAll(tempImages);
      });
    }
  }

  Future<File?> _applyFilter(File image) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoFilter(
          image: image,
          presets: defaultColorFilters,
          cancelIcon: Icons.cancel,
          applyIcon: Icons.check,
          backgroundColor: Colors.black,
          sliderColor: Colors.blue,
          sliderLabelStyle: const TextStyle(color: Colors.white),
          bottomButtonsTextStyle: const TextStyle(color: Colors.white),
          presetsLabelTextStyle: const TextStyle(color: Colors.white),
          applyingTextStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void _postImages() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one image")),
      );
      return;
    }

    final postBox = Hive.box<Post>('postsBox');
    Post post = Post(
        imagePaths: selectedImages.map((file) => file.path).toList(),
        caption: captionController.text.trim(),
        timestamp: DateTime.now());

    await postBox.add(post);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post added successfully!")),
    );

    // Clear selections after posting
    setState(() {
      selectedImages.clear();
      captionController.clear();
    });
  }

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.photos].request();
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showImagePicker,
            child: const Text('Pick and Filter Images'),
          ),
          if (selectedImages.isNotEmpty)
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(selectedImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: const CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 12,
                            child: Icon(Icons.close,
                                size: 15, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        left: 5,
                        child: GestureDetector(
                          onTap: () async => selectedImages[index] =
                              (await _applyFilter(selectedImages[index]))!,
                          child: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 12,
                            child: Icon(Icons.change_circle,
                                size: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: captionController,
              decoration: const InputDecoration(
                hintText: "Enter caption...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: _postImages,
              child: const Text("Post"),
            ),
          ),
        ],
      ),
    );
  }
}
