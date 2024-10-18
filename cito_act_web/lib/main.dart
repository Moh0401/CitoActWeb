import 'package:cito_act_web/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cito_act_web/app_routes.dart';
import 'package:cito_act_web/services/admin_service.dart';
import 'package:provider/provider.dart';
import 'package:cito_act_web/utils/nav_state.dart'; // Assurez-vous que ce fichier existe

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Création d'un administrateur par défaut
  AdminService adminService = AdminService();
  await adminService.createAdminIfNotExists();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NavState(),
      child: MyApp(),
    ),
    
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CitoAct',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Assurez-vous que cette route existe
      onGenerateRoute: (settings) {
        final route = RouteGenerator.generateRoute(settings);

        if (route is MaterialPageRoute) {
          return MaterialPageRoute(
            settings: route.settings,
            builder: (context) {
              return Consumer<NavState>(
                builder: (context, navState, child) {
                  // Mettre à jour la route sélectionnée
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    navState.setSelectedRoute(settings.name ?? '/login');
                  });
                  return route.builder!(context);
                },
              );
            },
          );
        }

        return route;
      },
    );
  }
}
