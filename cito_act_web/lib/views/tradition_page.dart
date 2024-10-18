import 'package:flutter/material.dart';
import 'package:cito_act_web/models/tradition_model.dart';
import 'package:cito_act_web/services/tradition_service.dart';
import 'package:cito_act_web/widgets/tradition_card.dart';
import '../widgets/stat_card.dart';

class TraditionPage extends StatefulWidget {
  @override
  _TraditionPageState createState() => _TraditionPageState();
}

class _TraditionPageState extends State<TraditionPage> {
  late Future<List<TraditionModel>> _pendingTraditions;
  late Future<List<TraditionModel>>
      _allTraditions; // Nouvelle variable pour toutes les traditions
  int totalTraditions = 0;
  int pendingTraditions = 0;

  @override
  void initState() {
    super.initState();
    fetchTraditions(); // Appelle une méthode pour récupérer toutes les traditions
  }

  Future<void> fetchTraditions() async {
    try {
      // Récupère toutes les traditions
      List<TraditionModel> allTraditions =
          await TraditionService().getTraditions();
      totalTraditions = allTraditions.length;

      // Récupère les traditions en attente
      List<TraditionModel> pendingTraditionsList =
          await TraditionService().getPendingTraditions();
      pendingTraditions = pendingTraditionsList.length;

      setState(() {
        _allTraditions =
            Future.value(allTraditions); // Stocke toutes les traditions
        _pendingTraditions = Future.value(
            pendingTraditionsList); // Stocke les traditions en attente
      });
    } catch (e) {
      setState(() {
        _allTraditions = Future.error(e);
        _pendingTraditions = Future.error(e);
      });
    }
  }

  Future<void> validateTradition(String traditionId) async {
    try {
      await TraditionService().validateTradition(traditionId);
      fetchTraditions(); // Refresh the list after validation
    } catch (e) {
      print('Error validating tradition: $e');
    }
  }

  Future<void> deleteTradition(String traditionId) async {
    try {
      await TraditionService().deleteTradition(traditionId);
      fetchTraditions(); // Refresh the list after deletion
    } catch (e) {
      print('Error deleting tradition: $e');
    }
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
                StatCard(
                  title: "TOTAL TRADITIONS",
                  value: totalTraditions.toString(),
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF464255),
                ),
                StatCard(
                  title: "TRADITIONS EN ATTENTE",
                  value: pendingTraditions.toString(),
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF464255),
                ),
              ],
            ),
          ),

          // Titre "TRADITION EN ATTENTE"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text(
              "TRADITION EN ATTENTE",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<TraditionModel>>(
              future: _pendingTraditions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Aucune tradition en attente trouvée'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      TraditionModel tradition = snapshot.data![index];
                      return TraditionCard(
                        tradition: tradition,
                        onValidate: () => validateTradition(tradition.id),
                        onDelete: () => deleteTradition(tradition.id),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
