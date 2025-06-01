import 'package:flutter/material.dart';
import 'package:plantpal/screens/plant_details_screen.dart';
import 'package:plantpal/screens/edit_plant_screen.dart';
import '../models/plant.dart';
import '../services/plant_service.dart';

class PlantListScreen extends StatelessWidget {
  final PlantService _plantService = PlantService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Plants')),
      body: StreamBuilder<List<Plant>>(
        stream: _plantService.getPlants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No plants added yet.'));
          }
          final plants = snapshot.data!;
          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading:
                          plant.imageUrl != null && plant.imageUrl!.isNotEmpty
                              ? Image.network(
                                plant.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : Icon(Icons.local_florist, size: 40),
                      title: Text(plant.name),
                      subtitle: Text(
                        'Type: ${plant.type}\n'
                        'Water every ${plant.wateringInterval} days',
                      ),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PlantDetailsScreen(plant: plant),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Switch(
                                value: plant.alarmEnabled ?? true,
                                onChanged: (value) async {
                                  await _plantService.plantsCollection
                                      .doc(plant.id)
                                      .update({'alarmEnabled': value});
                                  // Optionally, show a snackbar
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          value
                                              ? 'Alarm enabled for ${plant.name}'
                                              : 'Alarm disabled for ${plant.name}',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                label: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              EditPlantScreen(plant: plant),
                                    ),
                                  );
                                },
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.delete, color: Colors.red),
                                label: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text('Delete Plant'),
                                          content: Text(
                                            'Are you sure you want to delete ${plant.name}?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == true) {
                                    await _plantService.plantsCollection
                                        .doc(plant.id)
                                        .delete();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Plant deleted!'),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Plant',
      ),
    );
  }
}
