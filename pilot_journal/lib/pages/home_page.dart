import 'package:flutter/material.dart';
import 'package:pilot_journal/main.dart';
import 'add_destination_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Destination> _destinationList = [];

  void _navigateAndAddDestination(BuildContext context) async {
    final Destination? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDestinationPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _destinationList.add(result);
      });
    }
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
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(dest.title),
                    subtitle: Text(
                      '${dest.description}\n${dest.latitude != null ? 'Lat: ${dest.latitude}, Long: ${dest.longitude}' : ''}',
                    ),
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
