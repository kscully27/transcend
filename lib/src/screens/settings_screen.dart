import 'package:flutter/material.dart';
import 'color_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme Colors'),
            subtitle: const Text('Customize theme colors'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ColorSettingsScreen(),
              ),
            ),
          ),
          // Add more settings options here
        ],
      ),
    );
  }
} 