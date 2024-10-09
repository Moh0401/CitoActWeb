// lib/services/action_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/projet_model.dart';

class ProjetService {
  final CollectionReference _projetsCollection = FirebaseFirestore.instance.collection('projets');

  Future<List<ProjetModel>> getProjets() async {
    QuerySnapshot snapshot = await _projetsCollection.get();
    return snapshot.docs.map((doc) => ProjetModel.fromFirestore(doc)).toList();
  }

  Future<List<ProjetModel>> getPendingProjets() async {
    QuerySnapshot snapshot = await _projetsCollection
        .where('valider', isEqualTo: false)
        .get();
    return snapshot.docs.map((doc) => ProjetModel.fromFirestore(doc)).toList();
  }

  Future<void> addProjets(ProjetModel projet) async {
    await _projetsCollection.add(projet.toMap());
  }

  Future<void> updateProjetStatus(String projetId, bool valider) async {
    await _projetsCollection.doc(projetId).update({'valider': valider});
  }

  Future<void> deleteProjet(String projetId) async {
    await _projetsCollection.doc(projetId).delete();
  }
}