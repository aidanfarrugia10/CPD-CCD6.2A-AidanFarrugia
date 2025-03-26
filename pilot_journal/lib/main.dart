import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';
import 'services/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCsLqDMlKMnbUmH1ro2IirWfkxIfLIjG4M",
      authDomain: "pilotjournal-bacde.firebaseapp.com",
      projectId: "pilotjournal-bacde",
      storageBucket: "pilotjournal-bacde.firebasestorage.app",
      messagingSenderId: "427998652083",
      appId: "1:427998652083:web:336fa8fb3b265bb8d132c6",
      databaseURL:
          "https://pilotjournal-bacde-default-rtdb.europe-west1.firebasedatabase.app",
    ),
  );
  await NotificationService.init();
  runApp(const PilotDestinationTrackerApp());
}

class PilotDestinationTrackerApp extends StatelessWidget {
  const PilotDestinationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilot Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// Destination object
class Destination {
  final String title;
  final String airportName;
  final double? latitude;
  final double? longitude;

  Destination({
    required this.title,
    required this.airportName,
    this.latitude,
    this.longitude,
  });
}
