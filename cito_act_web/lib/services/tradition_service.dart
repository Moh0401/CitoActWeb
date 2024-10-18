import 'package:cito_act_web/models/tradition_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraditionService {
  final CollectionReference _traditionCollection = FirebaseFirestore.instance.collection('traditions');

  // Récupère toutes les traditions
  Future<List<TraditionModel>> getTraditions() async {
    QuerySnapshot snapshot = await _traditionCollection.get();
    return snapshot.docs.map((doc) => TraditionModel.fromFirestore(doc)).toList();
  }

  // Récupère les traditions en attente de validation
  Future<List<TraditionModel>> getPendingTraditions() async {
    QuerySnapshot snapshot = await _traditionCollection
        .where('valider', isEqualTo: false)
        .get();
    return snapshot.docs.map((doc) => TraditionModel.fromFirestore(doc)).toList();
  }

    // Méthode pour valider une tradition
  Future<void> validateTradition(String traditionId) async {
    await _traditionCollection.doc(traditionId).update({'valider': true});
  }

  // Ajoute une nouvelle tradition
  Future<void> addTradition(TraditionModel tradition) async {
    await _traditionCollection.add(tradition.toMap());
  }

  // Met à jour le statut de validation d'une tradition
  Future<void> updateTraditionStatus(String id, bool valider) async {
    await _traditionCollection.doc(id).update({'valider': valider});
  }

  // Supprime une tradition en utilisant son ID
  Future<void> deleteTradition(String id) async {
    await _traditionCollection.doc(id).delete();
  }
}
