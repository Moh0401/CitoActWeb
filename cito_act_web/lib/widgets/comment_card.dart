import 'package:flutter/material.dart';
import 'package:cito_act_web/models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final Function(String) onValidate;
  final Function(BuildContext, String) onDelete;

  const CommentCard({
    Key? key,
    required this.comment,
    required this.onValidate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => onValidate(comment.id),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF6887B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Valider'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => onDelete(context, comment.id),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF6887B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Supprimer'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              comment.text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF464255)),
            ),
          ],
        ),
      ),
    );
  }
}
