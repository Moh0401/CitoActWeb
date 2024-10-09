import 'package:cito_act_web/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // N'oubliez pas d'ajouter le package audioplayers
import 'package:url_launcher/url_launcher.dart';
import '../models/tradition_model.dart';

class TraditionCard extends StatelessWidget {
  final TraditionModel tradition;
  final VoidCallback onValidate;
  final VoidCallback onDelete;

  const TraditionCard({
    Key? key,
    required this.tradition,
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
                  backgroundImage: tradition.profilePic.isNotEmpty
                      ? NetworkImage(tradition.profilePic)
                      : const AssetImage('assets/images/logo.png')
                          as ImageProvider,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tradition.titre,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("${tradition.firstName} ${tradition.lastName}"),
                      Text("Téléphone: ${tradition.telephone}"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Description: ${tradition.description}"),
            Text("Localisation: ${tradition.localisation}"),
            Text("Date: ${tradition.date}"),
            if (tradition.imageUrl.isNotEmpty)
              Image.network(
                tradition.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text('Image non disponible'));
                },
              ),
            // Affichage des vidéos
            if (tradition.videos.isNotEmpty)
              Column(
                children: tradition.videos.map((videoUrl) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 200,
                      child: VideoPlayerWidget(
                          videoUrl:
                              videoUrl), // Remplacez par votre widget vidéo
                    ),
                  );
                }).toList(),
              ),
            // Affichage des fichiers audio
            if (tradition.audios.isNotEmpty)
              Column(
                children: tradition.audios.map((audioUrl) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        AudioPlayer player = AudioPlayer();
                        player.play(UrlSource(
                            audioUrl)); // Utilisez UrlSource au lieu d'une chaîne
                      },
                      child: Text('Écouter Audio'),
                    ),
                  );
                }).toList(),
              ),

            // Affichage des documents
            if (tradition.documents.isNotEmpty)
              Column(
                children: tradition.documents.map((documentUrl) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (await canLaunch(documentUrl)) {
                          await launch(documentUrl);
                        } else {
                          throw 'Could not launch $documentUrl';
                        }
                      },
                      child: Text('Ouvrir Document'),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onValidate,
                  child: Text('Valider'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Supprimer'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
