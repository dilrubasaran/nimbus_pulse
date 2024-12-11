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
    return Container(
      width: 250,
      color: bgPrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo ve Başlık
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/nimbuspulse_logo.svg',
                      width: 64,
                      height: 64,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 12, color: primaryTextColor),
                ),
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
          const Divider(color: secondaryTextColor), // Çizgi
          // Menü Öğeleri
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                    Icons.dashboard, "Dashboard", context, DashboardHome()),
                _buildMenuItem(Icons.computer, "Server", context, ServerPage()),
                _buildMenuItem(
                    Icons.bar_chart, "Reports", context, ReportsPage()),
                _buildMenuItem(
                    Icons.settings, "Settings", context, SettingsProfilePage()),
                _buildMenuItem(Icons.logout, "Log Out", context, LoginPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, BuildContext context, Widget targetPage) {
    return ListTile(
      leading: Icon(icon, color: secondaryTextColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontFamily: fontNunitoSans,
          color: secondaryTextColor,
        ),
      ),
      onTap: () {
        // Navigasyon
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
    );
  }
}
