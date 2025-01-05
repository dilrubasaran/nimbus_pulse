import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final String currentTab;

  const SettingsHeader({Key? key, required this.currentTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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
        ),
      ),
    );
  }

  Widget _buildTab(
      BuildContext context, String title, String route, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 32.0),
      child: InkWell(
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Color(0xFF177EC6) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Color(0xFF177EC6) : Color(0xFF64748B),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
