import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static const String _projectId = 'citoact'; // Remplacez par l'ID de votre projet
  final String _fcmUrl = 'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

  // Charger les informations du compte de service à partir d'un fichier JSON
  Future<ServiceAccountCredentials> _loadServiceAccount() async {
    final data = await rootBundle.loadString('assets/your-service-account.json'); // Placez le fichier JSON dans assets
    return ServiceAccountCredentials.fromJson(json.decode(data));
  }

  // Générer un jeton d'accès pour l'authentification
  Future<String> _getAccessToken() async {
    final credentials = await _loadServiceAccount();
    final client = await clientViaServiceAccount(credentials, ['https://www.googleapis.com/auth/firebase.messaging']);
    return client.credentials.accessToken.data;
  }

  Future<void> sendNotification(String fcmToken, String title, String body) async {
    try {
      final accessToken = await _getAccessToken();

      final response = await http.post(
        Uri.parse(_fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': fcmToken,
            'notification': {
              'title': title,
              'body': body,
            },
          }
        }),
      );

      if (response.statusCode == 200) {
        print("Notification envoyée avec succès.");
      } else {
        print("Échec de l'envoi de la notification : ${response.body}");
      }
    } catch (e) {
      print("Erreur lors de l'envoi de la notification : $e");
    }
  }
}
