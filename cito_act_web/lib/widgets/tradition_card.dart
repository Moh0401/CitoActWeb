import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Pour le plein écran
import '../models/tradition_model.dart';
import '../services/tradition_service.dart';

class TraditionCard extends StatefulWidget {
  final TraditionModel tradition;
  final Function onValidate; // Callback après validation
  final Function onDelete; // Callback après suppression

  TraditionCard(
      {required this.tradition,
      required this.onValidate,
      required this.onDelete});

  @override
  _TraditionCardState createState() => _TraditionCardState();
}

class _TraditionCardState extends State<TraditionCard> {
  late AudioPlayer _audioPlayer;
  late VideoPlayerController _videoPlayerController;
  final TraditionService _traditionService = TraditionService();
  bool _isFullScreen = false; // Pour gérer le mode plein écran
  bool _isNotificationSent =
      false; // Indicateur pour éviter les notifications multiples
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (widget.tradition.videoUrl.isNotEmpty) {
      _videoPlayerController =
          VideoPlayerController.network(widget.tradition.videoUrl)
            ..initialize().then((_) {
              setState(() {}); // Rebuild widget once video is initialized
            });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    if (widget.tradition.videoUrl.isNotEmpty) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }

  // Méthode pour afficher la vidéo en plein écran
  void _enterFullScreen() {
    setState(() {
      _isFullScreen = true;
    });
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Activer le mode plein écran
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]); // Orientation paysage
  }

  void _exitFullScreen() {
    setState(() {
      _isFullScreen = false;
    });
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge); // Désactiver le mode plein écran
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // Revenir à l'orientation portrait
  }

  // Méthode pour valider la tradition
  Future<void> _validateTradition() async {
    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Set a new timer
    _debounceTimer = Timer(Duration(milliseconds: 300), () async {
      if (!_isNotificationSent) {
        _isNotificationSent = true; // Prevent multiple notifications

        try {
          await _traditionService.updateTraditionStatus(
              widget.tradition.id, true, widget.tradition.userId);
          widget.onValidate(); // Callback after successful validation
        } catch (e) {
          print('Erreur lors de la validation: $e');
        } finally {
          // Reset the notification flag after processing
          _isNotificationSent = false;
        }
      }
    });
  }

  // Méthode pour supprimer la tradition
  Future<void> _deleteTradition() async {
    await _traditionService.deleteTradition(widget.tradition.id);
    widget.onDelete(); // Appel du callback après suppression
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de la tradition

            SizedBox(height: 8),

            // Profil utilisateur et autres informations
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.tradition.profilePic),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Nom: ${widget.tradition.firstName} ${widget.tradition.lastName}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Row pour le contenu (image, vidéo à gauche / description, autres infos à droite)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colonne gauche : image et vidéo
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Image de la tradition (imageUrl)
                      if (widget.tradition.imageUrl.isNotEmpty)
                        Image.network(
                          widget.tradition.imageUrl,
                          height: 360, // Hauteur définie à 360
                          width: 450, // Largeur définie à 450
                          fit: BoxFit.cover,
                        ),
                      SizedBox(height: 8),

                      // Vidéo
                      if (widget.tradition.videoUrl.isNotEmpty)
                        Column(
                          children: [
                            // Vidéo avec dimensions spécifiques
                            Container(
                              width: 450, // Largeur définie à 450
                              height: 360, // Hauteur définie à 360
                              child: VideoPlayer(_videoPlayerController),
                            ),
                            SizedBox(height: 8),

                            // Boutons pour contrôler la vidéo
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Bouton Lecture (Play)
                                IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: () {
                                    setState(() {
                                      _videoPlayerController.play();
                                    });
                                  },
                                ),
                                // Bouton Pause
                                IconButton(
                                  icon: Icon(Icons.pause),
                                  onPressed: () {
                                    setState(() {
                                      _videoPlayerController.pause();
                                    });
                                  },
                                ),
                                // Bouton Rejouer
                                IconButton(
                                  icon: Icon(Icons.replay),
                                  onPressed: () {
                                    setState(() {
                                      _videoPlayerController
                                          .seekTo(Duration.zero);
                                      _videoPlayerController.play();
                                    });
                                  },
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _enterFullScreen();
                                setState(() {
                                  _videoPlayerController.play();
                                });
                              },
                              icon: Icon(Icons.fullscreen),
                              label: Text('Plein écran'),
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF6887B0)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                SizedBox(width: 16),

                // Colonne droite : description, audio, document, et infos supplémentaires
                Expanded(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: 360), // Limite la largeur à 360
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre de la tradition
                        Text(
                          widget.tradition.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Description de la tradition
                        if (widget.tradition.description.isNotEmpty)
                          Text(
                            widget.tradition.description,
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 16),
                          ),
                        SizedBox(height: 16),

                        // Origine, praticiens, menaces
                        Text(
                          'Origine: ${widget.tradition.origine}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          'Praticiens: ${widget.tradition.praticiens}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          'Menaces: ${widget.tradition.menaces}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 16),

                        // Audio
                        if (widget.tradition.audioUrl.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: () async {
                              await _audioPlayer
                                  .play(UrlSource(widget.tradition.audioUrl));
                            },
                            icon: Icon(Icons.speaker),
                            label: Text('Écouter l\'audio'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF6887B0),
                            ),
                          ),

                        SizedBox(height: 16),

                        // Document
                        if (widget.tradition.documentUrl.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: () async {
                              final url = widget.tradition.documentUrl;
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Impossible d\'ouvrir le document';
                              }
                            },
                            icon: Icon(Icons.picture_as_pdf),
                            label: Text('Voir le document'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF6887B0),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Boutons pour l'admin (Valider ou Supprimer)
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Aligner à droite
              children: [
                // Bouton Valider
                ElevatedButton(
                  onPressed: _isNotificationSent ? null : _validateTradition,
                  child: Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF869FC0), // Couleur de fond #869FC0
                    foregroundColor: Colors.white, // Couleur de texte blanche
                  ),
                ),

                SizedBox(width: 8), // Espace entre les boutons

                // Bouton Supprimer
                ElevatedButton(
                  onPressed: _deleteTradition,
                  child: Text('Supprimer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF869FC0), // Couleur de fond #869FC0
                    foregroundColor: Colors.white, // Couleur de texte blanche
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
