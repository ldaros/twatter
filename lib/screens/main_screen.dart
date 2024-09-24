import 'dart:io';

import 'package:app2/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/twat.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import '../widgets/twat_composer_screen.dart';

class MainScreen extends StatefulWidget {
  final Function toggleTheme;

  const MainScreen({super.key, required this.toggleTheme});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> _widgetOptions = [];
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 0;
  List<Twat> twats = [];
  final Uuid _uuid = const Uuid();
  Function toggleTheme = () {};


  UserProfile userProfile = UserProfile(
    id: 'currentuser',
    name: 'Current User',
    handle: '@currentuser',
    profilePhotoUrl: 'https://picsum.photos/seed/${Random().nextInt(1000)}/200',
  );

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    _firestoreService.getTwats().listen((twats) {
      setState(() {
        this.twats = twats;
        _updateWidgetOptions();
      });
    });

    toggleTheme = widget.toggleTheme;

    _updateWidgetOptions();
  }

  Future<void> _loadUserProfile() async {
    final loadedProfile = await loadUserProfile();
    if (loadedProfile != null) {
      setState(() {
        userProfile = loadedProfile;
      });
    }
  }

  void _updateWidgetOptions() {
    _widgetOptions = <Widget>[
      HomeScreen(
          twats: twats,
          onNewTwat: _addNewTwat,
          onTwatAction: _handleTwatAction,
          onRefresh: _refreshTwats,
          ),
      const Center(child: Text('Search')),
      const Center(child: Text('Notifications')),
      const Center(child: Text('Messages')),
      ProfileScreen(
        userProfile: userProfile,
        onProfileUpdate: _updateUserProfile,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addNewTwat(String content, String? imageUrl, {String? replyToHandle}) {
    final newTwat = Twat(
      id: _uuid.v4(),
      userId: userProfile.id,
      username: userProfile.name,
      handle: userProfile.handle,
      content: content,
      timestamp: DateTime.now(),
      avatarUrl: userProfile.profilePhotoUrl,
      imageUrl: imageUrl,
      replyToHandle: replyToHandle,
    );
    _firestoreService.addTwat(newTwat);
  }

  void _handleTwatAction(String twatId, String action) async {
    final twatIndex = twats.indexWhere((twat) => twat.id == twatId);
    if (twatIndex != -1) {
      switch (action) {
        case 'like':
          _likeTwat(twatId);
          break;
        case 'retwat':
          final originalTwat = twats[twatIndex];
          final newTwat = Twat(
            id: _uuid.v4(),
            userId: userProfile.id,
            username: userProfile.name,
            handle: userProfile.handle,
            content: originalTwat.content,
            timestamp: DateTime.now(),
            avatarUrl: userProfile.profilePhotoUrl,
            imageUrl: originalTwat.imageUrl,
            retweetedFrom: originalTwat.handle,
          );
          final success = await _firestoreService.retwat(twatId, newTwat);
          if (success) {
            print('Retwat successful');
          } else {
            print('Retwat failed');
          }
          break;
        case 'reply':
          _openReplyComposer(twats[twatIndex]);
          break;
      }
    }
  }

  void _updateUserProfile(UserProfile updatedProfile) {
    setState(() {
      userProfile = updatedProfile;
      saveUserProfile(updatedProfile);
      _updateWidgetOptions();
    });
  }

  void _openTwatComposer() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => TwatComposerScreen(onSubmit: _addNewTwat, onImageUpload: _uploadImage)),
    );
  }

  void _openReplyComposer(Twat replyTo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TwatComposerScreen(
          onSubmit: (content, imageUrl) =>
              _addNewTwat(content, imageUrl, replyToHandle: replyTo.handle),
          onImageUpload: _uploadImage,
          replyTo: replyTo,
        ),
      ),
    );
  }

  Future<void> _refreshTwats() async {
    final latestTwats = await _firestoreService.getTwats().first;
    setState(() {
      twats = latestTwats;
      _updateWidgetOptions();
    });
  }

  void _likeTwat(String twatId) {
    print('Liking twat with ID: $twatId');
    _firestoreService.likeTwat(twatId);
  }

  Future<String> _uploadImage(File imageFile) async {
    return _firestoreService.uploadImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userProfile.profilePhotoUrl),
                  radius: 16,
                ),
                const SizedBox(width: 8),
                Text(userProfile.handle),
              ],
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(toggleTheme: toggleTheme),
                    ),
                  );
                },
              ),
            ],
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _openTwatComposer,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}