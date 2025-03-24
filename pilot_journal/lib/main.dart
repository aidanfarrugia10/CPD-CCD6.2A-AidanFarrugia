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

//Destination Object
class Destination {
  final String title;
  final String description;
  final double? latitude;
  final double? longitude;

  Destination({
    required this.title,
    required this.description,
    this.latitude,
    this.longitude,
  });
}
