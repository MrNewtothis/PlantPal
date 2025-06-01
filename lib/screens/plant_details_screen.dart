import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantDetailsScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailsScreen({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plant.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                plant.imageUrl != null && plant.imageUrl!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        plant.imageUrl!,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    )
                    : Icon(Icons.local_florist, size: 100, color: Colors.green),
                SizedBox(height: 24),
                Text(
                  plant.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8),
                Text(
                  plant.type,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                Divider(height: 32, thickness: 1.2),
                _infoRow(
                  Icons.water_drop,
                  'Watering Interval',
                  '${plant.wateringInterval} days',
                ),
                _infoRow(
                  Icons.eco,
                  'Fertilizing Interval',
                  '${plant.fertilizingInterval} days',
                ),
                _infoRow(
                  Icons.grass,
                  'Repotting Interval',
                  '${plant.repottingInterval} days',
                ),
                _infoRow(
                  Icons.opacity,
                  'Last Watered',
                  '${plant.lastWatered.toLocal().toString().split(' ')[0]}',
                ),
                _infoRow(
                  Icons.local_florist,
                  'Last Fertilized',
                  '${plant.lastFertilized.toLocal().toString().split(' ')[0]}',
                ),
                _infoRow(
                  Icons.local_florist,
                  'Last Repotted',
                  '${plant.lastRepotted.toLocal().toString().split(' ')[0]}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
