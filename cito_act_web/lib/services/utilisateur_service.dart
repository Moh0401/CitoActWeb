import 'package:cito_act_web/models/utilisatteur_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour récupérer la liste de tous les utilisateurs depuis Firestore
  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs : $e');
      return [];
    }
  }

  // Méthode pour récupérer un utilisateur spécifique par son UID
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur : $e');
    }
    return null;
  }

  // Méthode pour supprimer un utilisateur
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      print("Utilisateur supprimé avec succès");
    } catch (e) {
      print('Erreur lors de la suppression de l\'utilisateur : $e');
    }
  }

  // Compter le nombre d'utilisateurs dans Firestore
  Future<int> getTotalUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.size;
    } catch (e) {
      print('Erreur lors de la récupération du nombre d\'utilisateurs : $e');
      return 0;
    }
  }

  // Compter le nombre d'organisations basées sur le rôle des utilisateurs
  Future<int> getTotalOrganizations() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'organisation')
          .get();
      return snapshot.size;
    } catch (e) {
      print('Erreur lors de la récupération du nombre d\'organisations : $e');
      return 0;
    }
  }
}
