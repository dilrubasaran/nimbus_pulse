import 'package:flutter/material.dart';
import 'package:nimbus_pulse/pages/settings/settings_profile.dart';
import 'package:nimbus_pulse/pages/settings/settings_password.dart'; // Şifre sayfası
import 'package:nimbus_pulse/pages/settings/settings_security.dart';
import 'package:nimbus_pulse/pages/settings/settings_theme_language.dart'; // Tema ve dil sayfası

class SettingsHeader extends StatefulWidget {
  @override
  _SettingsHeaderState createState() => _SettingsHeaderState();
}

class _SettingsHeaderState extends State<SettingsHeader> {
  int _selectedIndex = 0; // Başlangıçta Profil sekmesi seçili olacak

  // Sayfalar
  final List<Widget> _pages = [
    SettingsProfilePage(),
    SettingsPasswordPage(),
    SettingsSecurityPage(),
    SettingsThemeLanguagePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sekme başlıkları
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            4,
            (index) => TabButton(
              title: _getTabTitle(index),
              isSelected: _selectedIndex == index,
              onTap: () {
                setState(() {
                  _selectedIndex = index; // Seçili sekmeyi güncelle
                });
                // Sayfaya yönlendir
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => _pages[index]),
                );
              },
            ),
          ),
        ),
        // Seçilen sayfa
        Expanded(
          child: _pages[_selectedIndex],
        ),
      ],
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return "Profil";
      case 1:
        return "Şifre";
      case 2:
        return "Güvenlik Kodu";
      case 3:
        return "Tema ve Dil Seçenekleri";
      default:
        return "";
    }
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Sekmeye tıklandığında onTap çağrılır
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
              color: isSelected
                  ? Colors.blue
                  : Colors.transparent, // Seçili sekme için mavi alt çizgi
              width: 2.0,
            )),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
