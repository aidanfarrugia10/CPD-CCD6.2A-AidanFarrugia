import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';
import '../services/notifications_service.dart';

class AddDestinationPage extends StatefulWidget {
  const AddDestinationPage({super.key});

  @override
  State<AddDestinationPage> createState() => _AddDestinationPageState();
}

class _AddDestinationPageState extends State<AddDestinationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _airportNameController = TextEditingController();
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('destinations');

  Position? _currentPosition;
  bool _isLocating = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLocating = false);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLocating = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLocating = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _isLocating = false;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final newDestination = Destination(
        title: _titleController.text,
        airportName: _airportNameController.text,
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
      );

      _dbRef.push().set({
        'title': newDestination.title,
        'airportName': newDestination.airportName,
        'latitude': newDestination.latitude,
        'longitude': newDestination.longitude,
      }).then((_) {
        NotificationService.show(
          'Destination Added',
          '“${newDestination.title}” saved successfully',
        );
      });

      Navigator.pop(context, newDestination);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _airportNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationDisplay = _currentPosition == null
        ? 'Location not fetched yet.'
        : 'Lat: ${_currentPosition!.latitude}, Long: ${_currentPosition!.longitude}';

    return Scaffold(
      appBar: AppBar(title: const Text('Add Destination')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: 'Destination Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _airportNameController,
                decoration: const InputDecoration(labelText: 'Airport Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLocating ? null : _getCurrentLocation,
                child: Text(_isLocating ? 'Locating...' : 'Get Location'),
              ),
              const SizedBox(height: 8),
              Text(locationDisplay),
              const SizedBox(height: 24),
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
