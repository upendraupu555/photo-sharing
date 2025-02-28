import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_sharing_app/utils/storage_service.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = StorageService.getUsername();
  String profilePic = StorageService.getProfilePic();
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _pickProfilePic() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profilePic = pickedFile.path;
      });
      await StorageService.saveUserProfile(username, profilePic);
    }
  }

  Future<void> _updateUsername() async {
    setState(() {
      username = _usernameController.text;
    });
    await StorageService.saveUserProfile(username, profilePic);
    Navigator.pop(context);
  }

  void _editProfile() {
    _usernameController.text = username;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: TextField(controller: _usernameController),
          actions: [
            TextButton(
              onPressed: _updateUsername,
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: [
          GestureDetector(
            onTap: _pickProfilePic,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: profilePic.isNotEmpty ? FileImage(File(profilePic)) : null,
              child: profilePic.isEmpty ? const Icon(Icons.person, size: 50) : null,
            ),
          ),
          const SizedBox(height: 10),
          Text(username, style: const TextStyle(fontSize: 18)),
          TextButton(onPressed: _editProfile, child: const Text("Edit Profile")),
        ],
      ),
    );
  }
}
