import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tradition_model.dart';

class TraditionService {
  final CollectionReference _traditionsCollection = FirebaseFirestore.instance.collection('traditions');

  Future<List<TraditionModel>> getTraditions() async {
    QuerySnapshot snapshot = await _traditionsCollection.get();
    return snapshot.docs.map((doc) => TraditionModel.fromFirestore(doc)).toList();
  }

  Future<List<TraditionModel>> getPendingTraditions() async {
    QuerySnapshot snapshot = await _traditionsCollection
        .where('valider', isEqualTo: false)
        .get();
    return snapshot.docs.map((doc) => TraditionModel.fromFirestore(doc)).toList();
  }

  Future<void> addTradition(TraditionModel tradition) async {
    await _traditionsCollection.add(tradition.toMap());
  }

  Future<void> updateTraditionStatus(String traditionId, bool valider) async {
    await _traditionsCollection.doc(traditionId).update({'valider': valider});
  }

  Future<void> deleteTradition(String traditionId) async {
    await _traditionsCollection.doc(traditionId).delete();
  }
}
