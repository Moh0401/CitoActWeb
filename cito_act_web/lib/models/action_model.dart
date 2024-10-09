// lib/models/action_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ActionModel {
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

  ActionModel({
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
  });
  factory ActionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ActionModel(
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
    };
  }
}
