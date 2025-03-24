import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';

class AddDestinationPage extends StatefulWidget {
  const AddDestinationPage({super.key});

  @override
  State<AddDestinationPage> createState() => _AddDestinationPageState();
}

class _AddDestinationPageState extends State<AddDestinationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Position? _currentPosition;

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = _currentPosition;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final newDestination = Destination(
        title: _titleController.text,
        description: _descriptionController.text,
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
      );
      Navigator.pop(context, newDestination);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationDisplay = _currentPosition == null
        ? 'Location not fetched yet.'
        : 'Lat: ${_currentPosition!.latitude}, Long: ${_currentPosition!.longitude}';

    return Scaffold(
      appBar: AppBar(title: const Text('Add Destination')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Destination Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('Get Current Location'),
              ),
              const SizedBox(height: 8),
              Text(locationDisplay),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Save Destination'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
