import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id; // ID du commentaire
  final String parentId; // ID du document parent (action, projet, tradition)
  final String
      collectionType; // Type de collection (comments_actions, comments_projets, comments_traditions)
  final String firstName; // Prénom de l'utilisateur
  final String lastName; // Nom de famille de l'utilisateur
  final String imageUrl; // URL de l'image de l'utilisateur
  final String text; // Texte du commentaire
  final Timestamp timestamp; // Horodatage du commentaire
  final bool isReported; // Indicateur si le commentaire est signalé

  CommentModel({
    required this.id,
    required this.parentId,
    required this.collectionType,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.text,
    required this.timestamp,
    required this.isReported,
  });

  // Méthode pour créer un CommentModel à partir d'un document Firestore
  factory CommentModel.fromFirestore(
      Map<String, dynamic> data, String id, String collectionType) {
    return CommentModel(
      id: id,
      parentId: data['parentId'] ?? '',
      collectionType: collectionType,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      isReported: data['isReported'] ?? false,
    );
  }
}
