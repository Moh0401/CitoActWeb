import 'package:flutter/material.dart';
import '../models/tradition_model.dart';
import '../services/tradition_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/tradition_card.dart';

class TraditionPage extends StatefulWidget {
  @override
  _TraditionPageState createState() => _TraditionPageState();
}

class _TraditionPageState extends State<TraditionPage> {
  final TraditionService _traditionService = TraditionService();
  List<TraditionModel> traditions = [];
  int totalTraditions = 0;
  int pendingTraditions = 0;

  @override
  void initState() {
    super.initState();
    fetchTraditions();
  }

  Future<void> fetchTraditions() async {
    List<TraditionModel> fetchedTraditions = await _traditionService.getTraditions();
    List<TraditionModel> fetchedPendingTraditions = await _traditionService.getPendingTraditions();
    setState(() {
      traditions = fetchedPendingTraditions;
      totalTraditions = fetchedTraditions.length;
      pendingTraditions = fetchedPendingTraditions.length;
    });
  }

  Future<void> validateTradition(String traditionId) async {
    await _traditionService.updateTraditionStatus(traditionId, true);
    fetchTraditions();
  }

  Future<void> deleteTradition(String traditionId) async {
    await _traditionService.deleteTradition(traditionId);
    fetchTraditions();
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
                  title: "TOTAL TRADITIONS",
                  value: totalTraditions.toString(),
                  backgroundColor: Colors.white,
                  textColor: Color(0xFF464255),
                ),
                StatCard(
                  title: "TRADITIONS EN ATTENTE",
                  value: pendingTraditions.toString(),
                  backgroundColor: Colors.white,
                  textColor: Color(0xFF464255),
                ),
              ],
            ),
          ),
          // Section des traditions en attente
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TRADITIONS EN ATTENTE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: traditions.length,
                      itemBuilder: (context, index) {
                        TraditionModel tradition = traditions[index];
                        return TraditionCard(
                          tradition: tradition,
                          onValidate: () => validateTradition(tradition.id),
                          onDelete: () => deleteTradition(tradition.id),
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
