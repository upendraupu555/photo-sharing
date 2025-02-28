import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_sharing_app/data/models/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box postBox;
  late Box likesBox;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Sharing'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo, color: Colors.purple),
            onPressed: () {
              Navigator.pushNamed(context, '/new_post');
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Post>('postsBox').listenable(),
        builder: (context, Box posts, _) {
          if (posts.isEmpty) {
            return const Center(child: Text("No posts available"));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final Post post = posts.getAt(index);
              final List<dynamic> imagePaths = post.imagePaths ?? [];
              final String caption = post.caption ?? '';
              final String timestamp = post.timestamp.toIso8601String().split("T")[0] ?? '';

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 250, // Fixed height for images
                      child: PageView.builder(
                        itemCount: imagePaths.length,
                        itemBuilder: (context, imgIndex) {
                          return Image.file(
                            File(imagePaths[imgIndex]),
                            width: double.infinity,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        caption,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        timestamp,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
