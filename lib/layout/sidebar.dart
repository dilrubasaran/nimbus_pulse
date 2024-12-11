import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nimbus_pulse/pages/Server.dart';
import 'package:nimbus_pulse/pages/dashboard_home.dart';
import 'package:nimbus_pulse/pages/login.dart';
import 'package:nimbus_pulse/pages/reports.dart';
import 'package:nimbus_pulse/pages/settings/settings_profile.dart';
import '../styles/consts.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ekran genişliğini al
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive genişlik belirle
    double sidebarWidth;
    bool showText;

    if (screenWidth < 600) {
      // Mobil
      sidebarWidth = 72; // Sadece ikonlar
      showText = false;
    } else if (screenWidth < 1200) {
      // Tablet
      sidebarWidth = screenWidth * 0.25; // İçerikle uyumlu genişlik
      showText = true;
    } else {
      // Web
      sidebarWidth = 250; // Varsayılan genişlik
      showText = true;
    }

    return Container(
      width: sidebarWidth,
      color: bgPrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showText) // Logo ve Başlık sadece geniş ekranlarda görünür
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/nimbuspulse_logo.svg',
                    width: 64,
                    height: 64,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome",
                    style: TextStyle(fontSize: 12, color: primaryTextColor),
                  ),

                  //! loginde ki kullanıcı ismi olacak
                  Text(
                    "Dilruba Başaran",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          if (showText) const Divider(color: secondaryTextColor), // Çizgi
          // Menü Öğeleri
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.dashboard, "Dashboard", context,
                    DashboardHome(), showText),
                _buildMenuItem(
                    Icons.computer, "Server", context, ServerPage(), showText),
                _buildMenuItem(Icons.bar_chart, "Reports", context,
                    ReportsPage(), showText),
                _buildMenuItem(Icons.settings, "Settings", context,
                    SettingsProfilePage(), showText),
                _buildMenuItem(
                    Icons.logout, "Log Out", context, LoginPage(), showText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context,
      Widget targetPage, bool showText) {
    return ListTile(
      leading: Icon(icon, color: secondaryTextColor),
      title: showText
          ? Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontFamily: fontNunitoSans,
                color: secondaryTextColor,
              ),
            )
          : null, //sadece icon gözüksün
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
    );
  }
}
