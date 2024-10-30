import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/projet_model.dart';
import '../services/projet_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/projet_card.dart';

class ProjetsPage extends StatefulWidget {
  @override
  _ProjetsPageState createState() => _ProjetsPageState();
}

class _ProjetsPageState extends State<ProjetsPage> {
  final ProjetService _projetService = ProjetService();
  List<ProjetModel> projets = [];
  int totalProjets = 0;
  int pendingProjets = 0;

  @override
  void initState() {
    super.initState();
    signIn();
    fetchProjets();
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      );
      print("Utilisateur connecté : ${userCredential.user?.uid}");
    } catch (e) {
      print("Erreur de connexion : $e");
    }
  }

  Future<void> fetchProjets() async {
    List<ProjetModel> fetchedProjets = await _projetService.getProjets();
    List<ProjetModel> fetchedPendingProjets =
        await _projetService.getPendingProjets();
    setState(() {
      projets = fetchedPendingProjets;
      totalProjets = fetchedProjets.length;
      pendingProjets = fetchedPendingProjets.length;
    });
  }

  Future<void> validateProjet(String projetId) async {
    // Trouver l'action correspondante dans la liste des actions
    ProjetModel? projet = projets.firstWhere(
      (a) => a.id == projetId,
      orElse: () => throw Exception('Projet non trouvée'),
    );

    await _projetService.updateProjetStatus(projetId, true, projet.userId);

    await fetchProjets(); // Rafraîchir la liste des actions
  }

  Future<void> deleteProjet(String projetId) async {
    ProjetModel? projet = projets.firstWhere(
      (a) => a.id == projetId,
      orElse: () => throw Exception('Projet non trouvée'),
    );

    await _projetService.deleteProjet(projetId);
    fetchProjets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6887B0),
      body: Column(
        children: [
          // Section des statistiques
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCard(
                  title: "TOTAL PROJETS",
                  value: totalProjets.toString(),
                  backgroundColor: Colors.white,
                  textColor: Color(0xFF464255),
                ),
                StatCard(
                  title: "PROJETS EN ATTENTE",
                  value: pendingProjets.toString(),
                  backgroundColor: Colors.white,
                  textColor: Color(0xFF464255),
                ),
              ],
            ),
          ),
          // Section des projets en attente
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PROJETS EN ATTENTE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: projets.length,
                      itemBuilder: (context, index) {
                        ProjetModel projet = projets[index];
                        return ProjetCard(
                          projet: projet,
                          onValidate: () => validateProjet(projet.id),
                          onDelete: () => deleteProjet(projet.id),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
