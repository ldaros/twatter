// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function toggleTheme;

  const SettingsScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: const Text('Twatter'),
            subtitle: const Text('Version 0.1.4'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Enable Dark Mode'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                toggleTheme(); // Calls the toggle function
              },
            ),
          ),
        ],
      ),
    );
  }
}
