import 'package:flutter/material.dart';

class BackgroundSound {
  final String name;
  final String path;
  final IconData icon;

  const BackgroundSound({
    required this.name,
    required this.path,
    required this.icon,
  });
}

const List<BackgroundSound> backgroundIcons = [
  BackgroundSound(
    name: 'Rain',
    path: 'rain.mp3',
    icon: Icons.water_drop,
  ),
  BackgroundSound(
    name: 'Ocean',
    path: 'ocean.mp3',
    icon: Icons.waves,
  ),
  BackgroundSound(
    name: 'Forest',
    path: 'forest.mp3',
    icon: Icons.forest,
  ),
  BackgroundSound(
    name: 'White Noise',
    path: 'white_noise.mp3',
    icon: Icons.noise_control_off,
  ),
]; 