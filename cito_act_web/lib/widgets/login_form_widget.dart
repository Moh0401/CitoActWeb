import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginFormWidget extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Authentification avec Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Redirection vers la page d'accueil si la connexion est réussie
      Navigator.pushReplacementNamed(context, '/action');
    } catch (e) {
      // Afficher une erreur si la connexion échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la connexion : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            _login(context); // Appel de la fonction de connexion
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
            backgroundColor: Color(0xFF6887B0),
          ),
          child: Text('Se connecter',
              style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFFF))),
        ),
      ],
    );
  }
}
