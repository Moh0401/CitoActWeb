// lib/widgets/action_card.dart

import 'package:flutter/material.dart';
import '../models/action_model.dart';

class ActionCard extends StatelessWidget {
  final ActionModel action;
  final VoidCallback onValidate;
  final VoidCallback onDelete;

  const ActionCard({
    Key? key,
    required this.action,
    required this.onValidate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: action.profilePic != null
                      ? NetworkImage(action.profilePic!)
                      : const AssetImage('assets/images/logo.png')
                          as ImageProvider,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.titre,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("${action.firstName} ${action.lastName}"),
                      Text("Téléphone: ${action.telephone}"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Description: ${action.description}"),
            Text("Localisation: ${action.localisation}"),
            Text("Besoin: ${action.besoin}"),
            Text("Début: ${action.debut}"),
            Text("Fin: ${action.fin}"),
            if (action.imageUrl.isNotEmpty)
              Image.network(
                action.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text('Image non disponible'));
                },
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onValidate,
                  child: Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF6887B0),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Supprimer'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF6887B0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
