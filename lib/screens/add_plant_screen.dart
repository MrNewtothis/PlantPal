import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/plant.dart';
import '../services/plant_service.dart';
import '../utils/notification_helper.dart';

class AddPlantScreen extends StatefulWidget {
  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final PlantService _plantService = PlantService();

  // Form fields
  String _name = '';
  String _type = '';
  int _wateringInterval = 1;
  int _fertilizingInterval = 1;
  int _repottingInterval = 1;
  DateTime _lastWatered = DateTime.now();
  DateTime _lastFertilized = DateTime.now();
  DateTime _lastRepotted = DateTime.now();
  String? _imageUrl;
  DateTime? _notificationTime;

  Future<void> _pickDate(
    BuildContext context,
    DateTime initial,
    Function(DateTime) onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onPicked(picked);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final plant = Plant(
        id: '',
        name: _name,
        type: _type,
        wateringInterval: _wateringInterval,
        fertilizingInterval: _fertilizingInterval,
        repottingInterval: _repottingInterval,
        lastWatered: _lastWatered,
        lastFertilized: _lastFertilized,
        lastRepotted: _lastRepotted,
        imageUrl: _imageUrl,
        notificationTime: _notificationTime,
      );
      await _plantService.addPlant(plant);

      if (plant.notificationTime != null) {
        try {
          await NotificationHelper.scheduleNotification(
            id: plant.id.hashCode,
            title: 'Water ${plant.name}',
            body: 'It\'s time to water your ${plant.name}!',
            scheduledDate: plant.notificationTime!,
          );
        } on PlatformException catch (e) {
          if (e.code == 'exact_alarms_not_permitted') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Exact alarms are not permitted. Please enable "Schedule exact alarms" in your device settings for PlantPal.',
                ),
              ),
            );
          }
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Plant added successfully!')));
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Plant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Plant Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Type'),
                validator: (v) => v == null || v.isEmpty ? 'Enter type' : null,
                onSaved: (v) => _type = v!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Watering Interval (days)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter interval' : null,
                onSaved: (v) => _wateringInterval = int.parse(v!),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fertilizing Interval (days)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter interval' : null,
                onSaved: (v) => _fertilizingInterval = int.parse(v!),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Repotting Interval (days)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter interval' : null,
                onSaved: (v) => _repottingInterval = int.parse(v!),
              ),
              ListTile(
                title: Text(
                  'Last Watered: ${_lastWatered.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap:
                    () => _pickDate(
                      context,
                      _lastWatered,
                      (d) => setState(() => _lastWatered = d),
                    ),
              ),
              ListTile(
                title: Text(
                  'Last Fertilized: ${_lastFertilized.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap:
                    () => _pickDate(
                      context,
                      _lastFertilized,
                      (d) => setState(() => _lastFertilized = d),
                    ),
              ),
              ListTile(
                title: Text(
                  'Last Repotted: ${_lastRepotted.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap:
                    () => _pickDate(
                      context,
                      _lastRepotted,
                      (d) => setState(() => _lastRepotted = d),
                    ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL (optional)'),
                onSaved: (v) => _imageUrl = v,
              ),

              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Add Plant')),
            ],
          ),
        ),
      ),
    );
  }
}
