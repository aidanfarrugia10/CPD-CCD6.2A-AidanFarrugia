// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const PilotDestinationTrackerApp());
}

class PilotDestinationTrackerApp extends StatelessWidget {
  const PilotDestinationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilot Destination Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class Destination {
  final String title;
  final String description;

  Destination({required this.title, required this.description});
}
