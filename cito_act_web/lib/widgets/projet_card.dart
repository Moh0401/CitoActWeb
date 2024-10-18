// lib/widgets/action_card.dart

import 'package:flutter/material.dart';
import '../models/projet_model.dart';

class ProjetCard extends StatelessWidget {
  final ProjetModel projet;
  final VoidCallback onValidate;
  final VoidCallback onDelete;

  const ProjetCard({
    Key? key,
    required this.projet,
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
                  backgroundImage: projet.profilePic != null
                      ? NetworkImage(projet.profilePic!)
                      : const AssetImage('assets/images/logo.png')
                          as ImageProvider,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projet.titre,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("${projet.firstName} ${projet.lastName}"),
                      Text("Téléphone: ${projet.telephone}"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Description: ${projet.description}"),
            Text("Localisation: ${projet.localisation}"),
            Text("Besoin: ${projet.besoin}"),
            Text("Début: ${projet.debut}"),
            Text("Fin: ${projet.fin}"),
            if (projet.imageUrl.isNotEmpty)
              Image.network(
                projet.imageUrl!,
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
