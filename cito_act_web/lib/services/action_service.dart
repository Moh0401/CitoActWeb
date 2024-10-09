// lib/services/action_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/action_model.dart';

class ActionService {
  final CollectionReference _actionsCollection = FirebaseFirestore.instance.collection('actions');

  Future<List<ActionModel>> getActions() async {
    QuerySnapshot snapshot = await _actionsCollection.get();
    return snapshot.docs.map((doc) => ActionModel.fromFirestore(doc)).toList();
  }

  Future<List<ActionModel>> getPendingActions() async {
    QuerySnapshot snapshot = await _actionsCollection
        .where('valider', isEqualTo: false)
        .get();
    return snapshot.docs.map((doc) => ActionModel.fromFirestore(doc)).toList();
  }

  Future<void> addAction(ActionModel action) async {
    await _actionsCollection.add(action.toMap());
  }

  Future<void> updateActionStatus(String actionId, bool valider) async {
    await _actionsCollection.doc(actionId).update({'valider': valider});
  }

  Future<void> deleteAction(String actionId) async {
    await _actionsCollection.doc(actionId).delete();
  }
}