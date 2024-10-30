// lib/services/action_service.dart

import 'package:cito_act_web/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/action_model.dart';

final NotificationService _notificationService = NotificationService();


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

 Future<void> updateActionStatus(String actionId, bool valider, String userId) async {
  // D'abord récupérer l'action
  DocumentSnapshot actionDoc = await _actionsCollection.doc(actionId).get();
  Map<String, dynamic> actionData = actionDoc.data() as Map<String, dynamic>;
  
  // Mettre à jour le statut
  await _actionsCollection.doc(actionId).update({'valider': valider});

  // Récupérer les informations nécessaires
  String titre = actionData['titre'] ?? '';
  String userId = actionData['userId'] ?? '';

  // Récupérer le token FCM de l'utilisateur
  DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();
  
  if (!userDoc.exists) {
    print("Utilisateur non trouvé");
    return;
  }

  String fcmToken = userDoc.get('fcmToken') ?? '';

  if (fcmToken.isNotEmpty) {
    try {
      await _notificationService.sendNotification(
        fcmToken,
        'Action Validée',
        'Votre action "$titre" a été validée.',
      );
      print("Notification envoyée avec succès.");
    } catch (e) {
      print("Erreur lors de l'envoi de la notification : $e");
    }
  } else {
    print("Token FCM non trouvé pour l'utilisateur");
  }
}

  Future<void> deleteAction(String actionId) async {
    // Récupérer l'action avant de la supprimer pour obtenir les informations nécessaires
    DocumentSnapshot actionDoc = await _actionsCollection.doc(actionId).get();
    Map<String, dynamic> actionData = actionDoc.data() as Map<String, dynamic>;

    String titre = actionData['titre'] ?? '';
    String userId = actionData['userId'] ?? '';

    // Supprimer l'action
    await _actionsCollection.doc(actionId).delete();

    // Récupérer le token FCM de l'utilisateur
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      String fcmToken = userDoc.get('fcmToken') ?? '';

      if (fcmToken.isNotEmpty) {
        // Envoyer la notification de suppression
        await _notificationService.sendNotification(
          fcmToken,
          'Action Supprimée',
          'Votre action "$titre" a été supprimée.',
        );
        print("Notification de suppression envoyée avec succès.");
      } else {
        print("Token FCM non trouvé pour l'utilisateur");
      }
    } else {
      print("Utilisateur non trouvé");
    }
  }
}