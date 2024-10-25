import 'package:cito_act_web/models/comment_model.dart';
import 'package:cito_act_web/services/comment_service.dart';
import 'package:cito_act_web/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import '../widgets/comment_card.dart';

class CommentReportedPage extends StatefulWidget {
  const CommentReportedPage({Key? key}) : super(key: key);

  @override
  _CommentReportedPageState createState() => _CommentReportedPageState();
}

class _CommentReportedPageState extends State<CommentReportedPage> {
  final CommentService _commentService = CommentService();
  List<CommentModel> reportedComments = [];
  int totalComments = 0;
  int reportedCommentsCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportedComments();
  }

  Future<void> fetchReportedComments() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<CommentModel> fetchedReportedComments =
          await _commentService.getReportedComments();

      if (mounted) {
        setState(() {
          reportedComments = fetchedReportedComments;
          totalComments = fetchedReportedComments.length; // Total comments
          reportedCommentsCount = fetchedReportedComments.length; // Reported comments count
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération des commentaires : $e");
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> validateComment(String commentId) async {
    try {
      await _commentService.validateComment(commentId);
      await fetchReportedComments(); // Refresh comments list after validation
    } catch (e) {
      print("Erreur lors de la validation du commentaire : $e");
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _commentService.deleteComment(commentId);
      await fetchReportedComments(); // Refresh comments list after deletion
    } catch (e) {
      print("Erreur lors de la suppression du commentaire : $e");
    }
  }

  void showDeleteConfirmation(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content: const Text("Êtes-vous sûr de vouloir supprimer ce commentaire ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                deleteComment(commentId);
                Navigator.of(context).pop();
              },
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6887B0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCard(
                  title: "TOTAL COMMENTAIRES",
                  value: totalComments.toString(),
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF464255),
                ),
                StatCard(
                  title: "COMMENTAIRES SIGNALÉS",
                  value: reportedCommentsCount.toString(),
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF464255),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "COMMENTAIRES SIGNALÉS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reportedComments.length,
                        itemBuilder: (context, index) {
                          CommentModel comment = reportedComments[index];
                          return CommentCard(
                            comment: comment,
                            onValidate: (commentId) {
                              validateComment(commentId);
                            },
                            onDelete: showDeleteConfirmation,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
