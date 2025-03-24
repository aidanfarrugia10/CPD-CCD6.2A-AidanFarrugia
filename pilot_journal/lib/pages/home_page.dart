import 'package:flutter/material.dart';
import 'add_destination_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinations'),
      ),
      body: const Center(
        child: Text('No destinations added yet, Please add some'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDestinationPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
