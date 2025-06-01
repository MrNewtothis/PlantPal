import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  String id;
  String name;
  String type;
  int wateringInterval;
  int fertilizingInterval;
  int repottingInterval;
  DateTime lastWatered;
  DateTime lastFertilized;
  DateTime lastRepotted;
  String? imageUrl;
  final bool alarmEnabled;
  DateTime? notificationTime; // <-- Add this

  Plant({
    required this.id,
    required this.name,
    required this.type,
    required this.wateringInterval,
    required this.fertilizingInterval,
    required this.repottingInterval,
    required this.lastWatered,
    required this.lastFertilized,
    required this.lastRepotted,
    this.imageUrl,
    this.alarmEnabled = true,
    this.notificationTime, // <-- Add this
  });

  factory Plant.fromMap(Map<String, dynamic> map, String id) {
    return Plant(
      id: id,
      name: map['name'],
      type: map['type'],
      wateringInterval: map['wateringInterval'],
      fertilizingInterval: map['fertilizingInterval'],
      repottingInterval: map['repottingInterval'],
      lastWatered: (map['lastWatered'] as Timestamp).toDate(),
      lastFertilized: (map['lastFertilized'] as Timestamp).toDate(),
      lastRepotted: (map['lastRepotted'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
      alarmEnabled: map['alarmEnabled'] ?? true,
      notificationTime:
          map['notificationTime'] != null
              ? (map['notificationTime'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'wateringInterval': wateringInterval,
      'fertilizingInterval': fertilizingInterval,
      'repottingInterval': repottingInterval,
      'lastWatered': lastWatered,
      'lastFertilized': lastFertilized,
      'lastRepotted': lastRepotted,
      'imageUrl': imageUrl,
      'alarmEnabled': alarmEnabled,
      'notificationTime': notificationTime, // <-- Add this
    };
  }
}
