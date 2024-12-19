import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final String currentTab;

  const SettingsHeader({Key? key, required this.currentTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTab(context, "Profil", "/settings/setting_profile",
            currentTab == "Profil"),
        _buildTab(context, "Şifre", "/settings/setting_password",
            currentTab == "Şifre"),
        _buildTab(context, "Tema", "/settings/setting_theme_language",
            currentTab == "Tema"),
        _buildTab(context, "Güvenlik Kodu", "/settings/setting_security",
            currentTab == "Güvenlik"),
      ],
    );
  }

  Widget _buildTab(
      BuildContext context, String title, String route, bool isSelected) {
    return TextButton(
      onPressed: () {
        Navigator.removeRoute(context, route as Route);
      },
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.transparent,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
