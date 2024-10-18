import 'package:cloud_firestore/cloud_firestore.dart';

class TraditionModel {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String origine;
  final String praticiens;
  final String menaces;
  final String profilePic;
  final String audioUrl;
  final String videoUrl;
  final String documentUrl;
  final String userId;
  final bool valider;
  final String description; // Champ ajouté
  final String imageUrl; // Champ ajouté

  TraditionModel({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.origine,
    required this.praticiens,
    required this.menaces,
    required this.profilePic,
    required this.audioUrl,
    required this.videoUrl,
    required this.documentUrl,
    required this.userId,
    required this.valider,
    required this.description, // Champ ajouté
    required this.imageUrl, // Champ ajouté
  });

  // Factory method pour créer une instance de TraditionModel à partir de Firestore
  factory TraditionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TraditionModel(
      id: doc.id,
      title: data['title'] ?? '', // Champs récupérés depuis Firestore
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      origine: data['origine'] ?? '',
      praticiens: data['praticiens'] ?? '',
      menaces: data['menaces'] ?? '',
      profilePic: data['profilePic'] ?? '',
      audioUrl: data['audioUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      documentUrl: data['documentUrl'] ?? '',
      userId: data['userId'] ?? '',
      valider: data['valider'] ?? false,
      description: data['description'] ?? '', // Champs description ajouté
      imageUrl: data['imageUrl'] ?? '', // Champs imageUrl ajouté
    );
  }

  // Méthode pour convertir TraditionModel en Map<String, dynamic> pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title, // Corrigé ici, titre -> title
      'firstName': firstName,
      'lastName': lastName,
      'origine': origine,
      'praticiens': praticiens,
      'menaces': menaces,
      'profilePic': profilePic,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'documentUrl': documentUrl,
      'userId': userId,
      'valider': valider,
      'description': description, // Ajout de la description
      'imageUrl': imageUrl, // Ajout de l'image URL
    };
  }
}
