import 'package:flutter/material.dart';
import 'dart:math';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onProfileUpdate,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _handleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _handleController = TextEditingController(text: widget.userProfile.handle);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    final updatedProfile = UserProfile(
      id: widget.userProfile.id,
      name: _nameController.text,
      handle: _handleController.text,
      profilePhotoUrl: widget.userProfile.profilePhotoUrl,
    );
    widget.onProfileUpdate(updatedProfile);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  void _changeProfilePhoto() {
    setState(() {
      widget.userProfile.profilePhotoUrl =
          'https://picsum.photos/seed/${Random().nextInt(1000)}/200';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _changeProfilePhoto,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(widget.userProfile.profilePhotoUrl),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap to change profile photo',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _handleController,
              decoration: const InputDecoration(
                labelText: 'Handle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}