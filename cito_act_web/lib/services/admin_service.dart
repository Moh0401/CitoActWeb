// lib/services/admin_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAdminIfNotExists() async {
    // Chercher si un administrateur existe déjà
    QuerySnapshot adminSnapshot = await _firestore.collection('users').where('role', isEqualTo: 'admin').get();

    if (adminSnapshot.docs.isEmpty) {
      // Si aucun administrateur n'existe, en créer un
      UserCredential adminCredential = await _auth.createUserWithEmailAndPassword(
        email: 'admin@example.com', // Adresse e-mail par défaut
        password: 'password123', // Mot de passe par défaut
      );

      // Ajouter l'administrateur à Firestore
      await _firestore.collection('users').doc(adminCredential.user?.uid).set({
        'uid': adminCredential.user?.uid,
        'email': 'admin@example.com',
        'role': 'admin',
        // Ajoute d'autres champs si nécessaire
      });
    }
  }
}
