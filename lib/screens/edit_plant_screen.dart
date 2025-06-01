import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/plant_service.dart';
import '../utils/notification_helper.dart';

class EditPlantScreen extends StatefulWidget {
  final Plant plant;

  const EditPlantScreen({Key? key, required this.plant}) : super(key: key);

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final PlantService _plantService = PlantService();

  late String _name;
  late String _type;
  late int _wateringInterval;
  late int _fertilizingInterval;
  late int _repottingInterval;
  late DateTime _lastWatered;
  late DateTime _lastFertilized;
  late DateTime _lastRepotted;
  String? _imageUrl;
  DateTime? _notificationTime;

  @override
  void initState() {
    super.initState();
    _name = widget.plant.name;
    _type = widget.plant.type;
    _wateringInterval = widget.plant.wateringInterval;
    _fertilizingInterval = widget.plant.fertilizingInterval;
    _repottingInterval = widget.plant.repottingInterval;
    _lastWatered = widget.plant.lastWatered;
    _lastFertilized = widget.plant.lastFertilized;
    _lastRepotted = widget.plant.lastRepotted;
    _imageUrl = widget.plant.imageUrl;
    _notificationTime = widget.plant.notificationTime;
  }

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
      final updatedPlant = Plant(
        id: widget.plant.id,
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
      await _plantService.plantsCollection
          .doc(updatedPlant.id)
          .set(updatedPlant.toMap());
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Plant updated!')));
        Navigator.pop(context);
      }
      if (updatedPlant.alarmEnabled && updatedPlant.notificationTime != null) {
        await NotificationHelper.scheduleNotification(
          id: updatedPlant.id.hashCode,
          title: 'Water ${updatedPlant.name}',
          body: 'It\'s time to water your ${updatedPlant.name}!',
          scheduledDate: updatedPlant.notificationTime!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Plant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Plant Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v!,
              ),
              TextFormField(
                initialValue: _type,
                decoration: InputDecoration(labelText: 'Type'),
                validator: (v) => v == null || v.isEmpty ? 'Enter type' : null,
                onSaved: (v) => _type = v!,
              ),
              TextFormField(
                initialValue: _wateringInterval.toString(),
                decoration: InputDecoration(
                  labelText: 'Watering Interval (days)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter interval' : null,
                onSaved: (v) => _wateringInterval = int.parse(v!),
              ),
              TextFormField(
                initialValue: _fertilizingInterval.toString(),
                decoration: InputDecoration(
                  labelText: 'Fertilizing Interval (days)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (v) => v == null || v.isEmpty ? 'Enter interval' : null,
                onSaved: (v) => _fertilizingInterval = int.parse(v!),
              ),
              TextFormField(
                initialValue: _repottingInterval.toString(),
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
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'Image URL (optional)'),
                onSaved: (v) => _imageUrl = v,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Save Changes')),
            ],
          ),
        ),
      ),
    );
  }
}
