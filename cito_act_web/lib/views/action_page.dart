// lib/pages/action_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/action_model.dart';
import '../services/action_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/action_card.dart';
import '../utils/nav_bar.dart';

class ActionPage extends StatefulWidget {
  @override
  _ActionPageState createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  final ActionService _actionService = ActionService();
  List<ActionModel> actions = [];
  int totalActions = 0;
  int pendingActions = 0;

  @override
  void initState() {
    super.initState();
    signIn(); // Appeler la méthode de connexion ici
    fetchActions();
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

  Future<void> fetchActions() async {
    List<ActionModel> fetchedActions = await _actionService.getActions();
    List<ActionModel> fetchedPendingActions =
        await _actionService.getPendingActions();
    setState(() {
      actions = fetchedPendingActions;
      totalActions = fetchedActions.length;
      pendingActions = fetchedPendingActions.length;
    });
  }

  Future<void> validateAction(String actionId) async {
    await _actionService.updateActionStatus(actionId, true);
    fetchActions();
  }

  Future<void> deleteAction(String actionId) async {
    await _actionService.deleteAction(actionId);
    fetchActions();
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
                  title: "TOTAL ACTIONS",
                  value: totalActions.toString(),
                  backgroundColor: Colors.white,
                  textColor: Color(0xFF464255),
                ),
                StatCard(
                  title: "ACTIONS EN ATTENTE",
                  value: pendingActions.toString(),
                  backgroundColor: Colors.white,
                  textColor: Color(0xFF464255),
                ),
              ],
            ),
          ),
          // Section des actions en attente
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ACTIONS EN ATTENTE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: actions.length,
                      itemBuilder: (context, index) {
                        ActionModel action = actions[index];
                        return ActionCard(
                          action: action,
                          onValidate: () => validateAction(action.id),
                          onDelete: () => deleteAction(action.id),
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
