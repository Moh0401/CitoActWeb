import 'package:cito_act_web/models/tradition_model.dart';
import 'package:cito_act_web/utils/nav_bar.dart';
import 'package:cito_act_web/utils/nav_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cito_act_web/views/commentaire_page.dart';
import 'package:cito_act_web/views/action_page.dart';
import 'package:cito_act_web/views/login_page.dart';
import 'package:cito_act_web/views/projets_page.dart';
import 'package:cito_act_web/views/tradition_page.dart';
import 'package:cito_act_web/views/utilisateur_page.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Vérifier si l'utilisateur est connecté
    if (FirebaseAuth.instance.currentUser == null && settings.name != '/login') {
      return MaterialPageRoute(builder: (_) => LoginPage());
    }

    Widget page;

    // Vérifier les routes
    switch (settings.name) {
      case '/login':
        page = LoginPage();
        break;
      case '/action':
        page = ActionPage();
        break;
      case '/projets':
        page = ProjetsPage();
        break;
      case '/traditions':
        page = TraditionPage();
        break;
      case '/utilisateur':
        page = UtilisateurPage();
        break;
      case '/commentaires':
        page = CommentReportedPage();
        break;
      default:
        return _errorRoute("Route non définie");
    }

    // Si ce n'est pas la page de connexion, ajouter la NavBar
    if (settings.name != '/login') {
      // On utilise le context correct pour obtenir NavState
      return MaterialPageRoute(
        builder: (context) {
          // Mettre à jour la route sélectionnée dans NavState
          Provider.of<NavState>(context, listen: false).setSelectedRoute(settings.name ?? '/action');
          return Scaffold(
            body: Row(
              children: [
                NavBar(), // Affichage de la barre de navigation
                Expanded(child: page), // Afficher la page sélectionnée
              ],
            ),
          );
        },
        settings: settings,
      );
    } else {
      // Retourner directement la page pour '/login'
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    }
  }

  // Fonction pour afficher une page d'erreur
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Erreur")),
        body: Center(child: Text(message)),
      );
    });
  }
}
