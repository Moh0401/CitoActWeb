import 'package:cloud_firestore/cloud_firestore.dart';

class TraditionModel {
  final String id;
  final String titre;
  final String description;
  final String localisation;
  final String date;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String profilePic;
  final String telephone;
  final String userId;
  final bool valider;
  final List<String> videos; // Pour les vidéos
  final List<String> audios; // Pour les fichiers audio
  final List<String> documents; // Pour les documents

  TraditionModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.localisation,
    required this.date,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.profilePic,
    required this.telephone,
    required this.userId,
    required this.valider,
    required this.videos,
    required this.audios, // Champ pour les audios
    required this.documents, // Champ pour les documents
  });

  factory TraditionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TraditionModel(
      id: doc.id,
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      localisation: data['localisation'] ?? '',
      date: data['date'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      profilePic: data['profilePic'] ?? '',
      telephone: data['telephone'] ?? '',
      userId: data['userId'] ?? '',
      valider: data['valider'] ?? false,
      videos: List<String>.from(data['videos'] ?? []),
      audios: List<String>.from(data['audios'] ?? []), // Récupération des audios
      documents: List<String>.from(data['documents'] ?? []), // Récupération des documents
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'localisation': localisation,
      'date': date,
      'firstName': firstName,
      'lastName': lastName,
      'imageUrl': imageUrl,
      'profilePic': profilePic,
      'telephone': telephone,
      'userId': userId,
      'valider': valider,
      'videos': videos,
      'audios': audios, // Ajout des audios
      'documents': documents, // Ajout des documents
    };
  }
}
