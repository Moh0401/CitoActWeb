import 'package:cito_act_web/models/tradition_model.dart';
import 'package:cito_act_web/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final NotificationService _notificationService = NotificationService();


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
 

 // Met à jour le statut de validation d'une tradition et envoie une notification
  Future<void> updateTraditionStatus(String id, bool valider, String userId) async {
    try {
      DocumentSnapshot traditionDoc = await _traditionCollection.doc(id).get();
      Map<String, dynamic> traditionData = traditionDoc.data() as Map<String, dynamic>;

      await _traditionCollection.doc(id).update({'valider': valider});

      String titre = traditionData['titre'] ?? '';
      String userId = traditionData['userId'] ?? '';

      // Récupérer le token FCM de l'utilisateur
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        String fcmToken = userDoc.get('fcmToken') ?? '';

        if (fcmToken.isNotEmpty) {
          await _notificationService.sendNotification(
            fcmToken,
            'Tradition Validée',
            'Votre tradition "$titre" a été validée.',
          );
          print("Notification envoyée avec succès.");
        } else {
          print("Token FCM non trouvé pour l'utilisateur");
        }
      } else {
        print("Utilisateur non trouvé");
      }
    } catch (e) {
      print("Erreur lors de la mise à jour du statut de la tradition : $e");
    }
  }

  // Supprime une tradition et envoie une notification
  Future<void> deleteTradition(String id) async {
    try {
      DocumentSnapshot traditionDoc = await _traditionCollection.doc(id).get();
      Map<String, dynamic> traditionData = traditionDoc.data() as Map<String, dynamic>;

      String titre = traditionData['titre'] ?? '';
      String userId = traditionData['userId'] ?? '';

      await _traditionCollection.doc(id).delete();

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        String fcmToken = userDoc.get('fcmToken') ?? '';

        if (fcmToken.isNotEmpty) {
          await _notificationService.sendNotification(
            fcmToken,
            'Tradition Supprimée',
            'Votre tradition "$titre" a été supprimée.',
          );
          print("Notification de suppression envoyée avec succès.");
        } else {
          print("Token FCM non trouvé pour l'utilisateur");
        }
      } else {
        print("Utilisateur non trouvé");
      }
    } catch (e) {
      print("Erreur lors de la suppression de la tradition : $e");
    }
  }
}
