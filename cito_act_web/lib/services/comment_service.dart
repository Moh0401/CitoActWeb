import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cito_act_web/models/comment_model.dart';

class CommentService {
  final CollectionReference commentsRef = FirebaseFirestore.instance.collection('comments');

  Future<List<CommentModel>> getReportedComments() async {
    List<CommentModel> allReportedComments = [];

    try {
      // Recherche de tous les commentaires signalés
      QuerySnapshot snapshot = await commentsRef.where('isReported', isEqualTo: true).get();

      // Ajouter à la liste
      allReportedComments.addAll(snapshot.docs.map((doc) {
        return CommentModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id, 'comments');
      }));
    } catch (e) {
      print("Erreur lors de la récupération des commentaires signalés : $e");
    }

    return allReportedComments;
  }

  Future<void> validateComment(String commentId) async {
    try {
      // Mise à jour du commentaire signalé pour le marquer comme non signalé
      await commentsRef.doc(commentId).update({'isReported': false});
    } catch (e) {
      print("Erreur lors de la validation du commentaire : $e");
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      // Suppression du commentaire
      await commentsRef.doc(commentId).delete();
    } catch (e) {
      print("Erreur lors de la suppression du commentaire : $e");
    }
  }
}
