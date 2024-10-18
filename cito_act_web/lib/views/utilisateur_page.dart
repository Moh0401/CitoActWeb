import 'package:cito_act_web/models/utilisatteur_model.dart';
import 'package:cito_act_web/services/utilisateur_service.dart';
import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';

class UtilisateurPage extends StatefulWidget {
  @override
  _UtilisateurPageState createState() => _UtilisateurPageState();
}

class _UtilisateurPageState extends State<UtilisateurPage> {
  UserService userService = UserService();
  List<UserModel> utilisateurs = [];
  int totalUtilisateurs = 0;
  int totalOrganisations = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Charger les utilisateurs
    List<UserModel> users = await userService.getUsers();
    // Charger les statistiques
    int usersCount = await userService.getTotalUsers();
    int orgCount = await userService.getTotalOrganizations();

    setState(() {
      utilisateurs = users;
      totalUtilisateurs = usersCount;
      totalOrganisations = orgCount;
    });
  }

  Future<void> _deleteUser(String uid) async {
    await userService.deleteUser(uid);
    // Après suppression, recharger les données
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6887B0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Statistique: Total Utilisateurs
                StatCard(
                  title: "TOTAL UTILISATEURS",
                  value: totalUtilisateurs.toString(),
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF464255),
                ),
                // Statistique: Total Organisations
                StatCard(
                  title: "TOTAL ORGANISATIONS LOCALES/ONG",
                  value: totalOrganisations.toString(),
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF464255),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text(
              "Liste des utilisateurs",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              itemCount: utilisateurs.length,
              itemBuilder: (context, index) {
                UserModel user = utilisateurs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(user.imageUrl),
                              radius: 30,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF464255),
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF464255),
                                  ),
                                ),
                                Text(
                                  'Téléphone: ${user.phone}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF464255),
                                  ),
                                ),
                                Text(
                                  'Rôle: ${user.role}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF464255),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon:
                                  Icon(Icons.delete, color: Color(0xFF6887B0)),
                              onPressed: () async {
                                bool? confirm = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirmer la suppression'),
                                    content: Text(
                                        'Voulez-vous vraiment supprimer cet utilisateur ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text('Annuler'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text('Supprimer'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await _deleteUser(user.uid);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
