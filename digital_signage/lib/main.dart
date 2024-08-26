import 'package:digital_signage/play.dart';
import 'package:flutter/material.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

void main() {
  VideoPlayerMediaKit.ensureInitialized(linux: true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Digital Signage',
        debugShowCheckedModeBanner: false,
        home: Play());
  }
}
