import 'package:flutter/material.dart';

class NavState extends ChangeNotifier {
  String _selectedRoute = '/action';

  String get selectedRoute => _selectedRoute;

  void setSelectedRoute(String route) {
    _selectedRoute = route;
    notifyListeners();
  }
}