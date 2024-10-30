// lib/services/action_service.dart

import 'package:cito_act_web/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/projet_model.dart';

final NotificationService _notificationService = NotificationService();


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



   Future<void> updateProjetStatus(String projetId, bool valider, String userId) async {
  // D'abord récupérer l'action
  DocumentSnapshot projetDoc = await _projetsCollection.doc(projetId).get();
  Map<String, dynamic> projetData = projetDoc.data() as Map<String, dynamic>;
  
  // Mettre à jour le statut
  await _projetsCollection.doc(projetId).update({'valider': valider});

  // Récupérer les informations nécessaires
  String titre = projetData['titre'] ?? '';
  String userId = projetData['userId'] ?? '';

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
        'Projet Validée',
        'Votre projet "$titre" a été validée.',
      );
      print("Notification envoyée avec succès.");
    } catch (e) {
      print("Erreur lors de l'envoi de la notification : $e");
    }
  } else {
    print("Token FCM non trouvé pour l'utilisateur");
  }
}

 

   Future<void> deleteProjet(String projetId) async {
    // Récupérer l'action avant de la supprimer pour obtenir les informations nécessaires
    DocumentSnapshot projetDoc = await _projetsCollection.doc(projetId).get();
    Map<String, dynamic> projetData = projetDoc.data() as Map<String, dynamic>;

    String titre = projetData['titre'] ?? '';
    String userId = projetData['userId'] ?? '';

    // Supprimer l'action
    await _projetsCollection.doc(projetId).delete();

    // Récupérer le token FCM de l'utilisateur
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      String fcmToken = userDoc.get('fcmToken') ?? '';

      if (fcmToken.isNotEmpty) {
        // Envoyer la notification de suppression
        await _notificationService.sendNotification(
          fcmToken,
          'Projet Supprimée',
          'Votre projet "$titre" a été supprimée.',
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