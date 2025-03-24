import 'package:flutter/material.dart';

class AddDestinationPage extends StatelessWidget {
  const AddDestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Destination'),
      ),
      body: const Center(
        child: Text('Form Placement'),
      ),
    );
  }
}
