import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final String currentTab;

  const SettingsHeader({Key? key, required this.currentTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTab(context, "Profil", "/settings/settings_profile",
            currentTab == "Profil"),
        _buildTab(context, "Şifre", "/settings/settings_password",
            currentTab == "Şifre"),
        _buildTab(context, "Tema", "/settings/settings_theme_language",
            currentTab == "Tema"),
        _buildTab(context, "Güvenlik Kodu", "/settings/settings_security",
            currentTab == "Güvenlik Kodu"),
      ],
    );
  }

  Widget _buildTab(
      BuildContext context, String title, String route, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
