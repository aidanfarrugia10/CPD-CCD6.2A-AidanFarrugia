import 'package:firebase_database/firebase_database.dart';
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
  bool _isLocating = false;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child('destinations');

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLocating = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLocating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLocating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLocating = false;
      });
    } catch (e) {
      setState(() => _isLocating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final newDestination = Destination(
        title: _titleController.text,
        description: _descriptionController.text,
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
      );

      _dbRef.push().set({
        'title': newDestination.title,
        'description': newDestination.description,
        'latitude': newDestination.latitude,
        'longitude': newDestination.longitude,
      });

      Navigator.pop(context, newDestination);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationDisplay = _currentPosition == null
        ? 'Location not fetched yet.'
        : 'Lat: ${_currentPosition!.latitude}, Long: ${_currentPosition!.longitude}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Destination'),
      ),
      body: SingleChildScrollView(
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
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLocating ? null : _getCurrentLocation,
                child: _isLocating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Get Current Location'),
              ),
              const SizedBox(height: 8),
              Text(locationDisplay, style: const TextStyle(fontSize: 14)),
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
