import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginFormWidget extends StatefulWidget {
  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Authentification avec Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Vérifier le rôle de l'utilisateur dans Firestore
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc.get('role');
          if (role == 'admin') {
            // Redirection vers la page d'action si l'utilisateur est un admin
            Navigator.pushReplacementNamed(context, '/action');
          } else {
            // Si l'utilisateur n'est pas un admin, afficher une erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Accès refusé : Vous n\'êtes pas administrateur.')),
            );
            await FirebaseAuth.instance
                .signOut(); // Déconnexion de l'utilisateur
          }
        }
      }
    } catch (e) {
      // Afficher une erreur si la connexion échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la connexion : ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
