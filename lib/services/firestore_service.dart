
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/perfume.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Perfumes
  Stream<List<Perfume>> getPerfumes() {
    return _db.collection('perfumes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Perfume.fromFirestore(doc)).toList());
  }

  Future<void> addPerfume(Perfume perfume) {
    return _db.collection('perfumes').add(perfume.toFirestore());
  }

  Future<void> updatePerfume(Perfume perfume) {
    return _db
        .collection('perfumes')
        .doc(perfume.id)
        .update(perfume.toFirestore());
  }

  Future<void> deletePerfume(String perfumeId) {
    return _db.collection('perfumes').doc(perfumeId).delete();
  }
}
