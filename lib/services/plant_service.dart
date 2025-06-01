import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant.dart';

class PlantService {
  final CollectionReference plantsCollection = FirebaseFirestore.instance
      .collection('plants');

  Future<void> addPlant(Plant plant) async {
    await plantsCollection.add(plant.toMap());
  }

  Stream<List<Plant>> getPlants() {
    return plantsCollection.snapshots().map((snapshot) {
      print('Fetched ${snapshot.docs.length} plants from Firestore');
      return snapshot.docs
          .map(
            (doc) => Plant.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }
}
