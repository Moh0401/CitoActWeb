// lib/models/action_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ProjetModel {
  final String id;
  final String titre;
  final String description;
  final String localisation;
  final String besoin;
  final String debut;
  final String fin;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String profilePic;
  final String telephone;
  final String userId;
  final bool valider;
  final String fcmToken; // Ajouter ce champ


  ProjetModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.localisation,
    required this.besoin,
    required this.debut,
    required this.fin,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.profilePic,
    required this.telephone,
    required this.userId,
    required this.valider,
    required this.fcmToken,

  });
  factory ProjetModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProjetModel(
      id: doc.id,
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      localisation: data['localisation'] ?? '',
      besoin: data['besoin'] ?? '',
      debut: data['debut'] ?? '',
      fin: data['fin'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      profilePic: data['profilePic'] ?? '',
      telephone: data['telephone'] ?? '',
      userId: data['userId'] ?? '',
      valider: data['valider'] ?? false,
      fcmToken: data['fcmToken'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'localisation': localisation,
      'besoin': besoin,
      'debut': debut,
      'fin': fin,
      'firstName': firstName,
      'lastName': lastName,
      'imageUrl': imageUrl,
      'profilePic': profilePic,
      'telephone': telephone,
      'userId': userId,
      'valider': valider,
      'fcmToken': fcmToken, // Ajouté ici
    };
  }
}
