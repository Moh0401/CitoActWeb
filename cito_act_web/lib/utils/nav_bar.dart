import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nav_state.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavState>(
      builder: (context, navState, child) {
        return Container(
          width: 250,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset('assets/images/logo_1.png', width: 100),
              ),
              SizedBox(height: 40),

              // Navigation Items
              _buildNavItem(context, Icons.emoji_emotions, "Action", "/action"),
              _buildNavItem(context, Icons.lightbulb, "Projets", "/projets"),
              _buildNavItem(
                  context, Icons.emoji_nature, "Traditions", "/traditions"),
              _buildNavItem(
                  context, Icons.person, "Utilisateur", "/utilisateur"),
              _buildNavItem(
                  context, Icons.comment, "Commentaires", "/commentaires"),

              Spacer(),

              // Logout Button
              SizedBox(
                height: 60,
                child: Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/logout');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      side: BorderSide(color: Color(0xFF6887B0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Déconnexion',
                      style: TextStyle(color: Color(0xFF6887B0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, String route) {
    return Consumer<NavState>(
      builder: (context, navState, child) {
        bool isSelected = navState.selectedRoute == route;
        return GestureDetector(
          onTap: () {
            navState.setSelectedRoute(route);
            Navigator.pushNamed(context, route);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF6887B0) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              leading: Icon(
                icon,
                color: isSelected ? Colors.white : Color(0xFF464255),
              ),
              title: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF464255),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
