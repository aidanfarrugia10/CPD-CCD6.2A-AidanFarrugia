import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';
import 'add_destination_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('destinations');
  final List<Destination> _destinationList = [];

  @override
  void initState() {
    super.initState();
    _listenToDatabase();
  }

  void _listenToDatabase() {
    _dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final List<Destination> loaded = [];
        data.forEach((key, value) {
          final map = Map<String, dynamic>.from(value);
          loaded.add(
            Destination(
              title: map['title'] ?? '',
              description: map['description'] ?? '',
              latitude: map['latitude']?.toDouble(),
              longitude: map['longitude']?.toDouble(),
            ),
          );
        });
        setState(() {
          _destinationList.clear();
          _destinationList.addAll(loaded);
        });
      }
    });
  }

  void _navigateAndAddDestination(BuildContext context) async {
    final Destination? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDestinationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilot Journal'),
      ),
      body: _destinationList.isEmpty
          ? const Center(child: Text('No destinations added yet.'))
          : ListView.builder(
              itemCount: _destinationList.length,
              itemBuilder: (context, index) {
                final dest = _destinationList[index];
                final location =
                    (dest.latitude != null && dest.longitude != null)
                        ? '\nLat: ${dest.latitude}, Long: ${dest.longitude}'
                        : '';
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(dest.title),
                    subtitle: Text('${dest.description}$location'),
                    leading: const Icon(Icons.flight_takeoff),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndAddDestination(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
