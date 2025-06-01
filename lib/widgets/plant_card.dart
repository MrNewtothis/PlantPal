import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback? onTap;

  const PlantCard({Key? key, required this.plant, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
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
        onTap: onTap,
      ),
    );
  }
}
