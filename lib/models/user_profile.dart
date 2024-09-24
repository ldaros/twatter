import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String id;
  String name;
  String handle;
  String profilePhotoUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.handle,
    required this.profilePhotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      handle: map['handle'],
      profilePhotoUrl: map['profilePhotoUrl'],
    );
  }
}

Future<void> saveUserProfile(UserProfile userProfile) async {
  final prefs = await SharedPreferences.getInstance();
  final userProfileString = jsonEncode(userProfile.toMap());
  await prefs.setString('userProfile', userProfileString);
}

Future<UserProfile?> loadUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final userProfileString = prefs.getString('userProfile');
  if (userProfileString != null) {
    try {
      final userProfileMap = jsonDecode(userProfileString) as Map<String, dynamic>;
      return UserProfile.fromMap(userProfileMap);
    } catch (e) {
      print('Error decoding user profile: $e');
      return null;
    }
  }
  return null;
}