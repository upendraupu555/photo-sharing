import 'dart:io';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String username;
  final String imageUrl;
  final String caption;

  const PostItem({
    super.key,
    required this.username,
    required this.imageUrl,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: Text(username.isNotEmpty ? username[0].toUpperCase() : "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(username,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imageUrl),
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(caption, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
