import 'package:cito_act_web/utils/nav_bar.dart';
import 'package:cito_act_web/utils/nav_state.dart';
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
    Widget page;
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
        page = CommentairePage();
        break;
      default:
        page = LoginPage();
    }

    // Wrap each page with a Row that includes NavBar

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Row(
          children: [
            NavBar(),
            Expanded(
              child: Consumer<NavState>(
                builder: (context, navState, child) {
                  // Mettre à jour la route sélectionnée
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    navState.setSelectedRoute(settings.name ?? '/action');
                  });
                  return page;
                },
              ),
            ),
          ],
        ),
      ),
      settings: settings,
    );
  }
}
