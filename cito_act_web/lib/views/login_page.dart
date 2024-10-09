import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../widgets/login_form_widget.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Partie de gauche (Formulaire)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWidget(), // Widget pour le logo
                  SizedBox(height: 50),
                  LoginFormWidget(), // Widget pour le formulaire de connexion
                ],
              ),
            ),
          ),
          // Partie de droite (Image)
          Expanded(
            child: Image.asset(
              'assets/images/action-citoyenne.png', // Remplace par l'image appropriée
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
