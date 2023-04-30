// ignore_for_file: prefer_const_constructors

import 'package:personal_assistant/homeScreen.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class JantungJarvis extends StatefulWidget {
  const JantungJarvis({super.key});

  @override
  State<JantungJarvis> createState() => _JantungJarvisState();
}

class _JantungJarvisState extends State<JantungJarvis> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

void runVolumeControl() async {
  final process =
      await Process.run('python', ['volume_gesture_control_python/control_pusat.py']);
  print(process.stdout);
}

void runCursorControl() async {
  final process =
      await Process.run('python', ['cursor_gesture_control_python/cursor.py']);
  print(process.stdout);
}