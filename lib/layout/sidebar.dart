import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../styles/consts.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // Aktif route bilgisini saklayacak
  String activeRoute = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double sidebarWidth;
    bool showText;

    if (screenWidth < 600) {
      sidebarWidth = 72;
      showText = false;
    } else if (screenWidth < 1200) {
      sidebarWidth = screenWidth * 0.25;
      showText = true;
    } else {
      sidebarWidth = 250;
      showText = true;
    }

    return Container(
      width: sidebarWidth,
      color: bgPrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showText)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
          if (showText) const Divider(color: secondaryTextColor),
          Expanded(
            child: ListView(
              children: _buildMenuItems(showText),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(bool showText) {
    final menuItems = [
      {'icon': Icons.dashboard, 'title': 'Dashboard', 'route': '/dashboard'},
      {'icon': Icons.computer, 'title': 'Server', 'route': '/server'},
      {'icon': Icons.bar_chart, 'title': 'Reports', 'route': '/reports'},
      {
        'icon': Icons.settings,
        'title': 'Settings',
        'route': '/settings/settings_profile'
      },
      {'icon': Icons.logout, 'title': 'Log Out', 'route': '/login'},
    ];

    return menuItems.map((item) {
      return ListTile(
        leading: Icon(
          item['icon'] as IconData,
          color:
              activeRoute == item['route'] ? Colors.blue : secondaryTextColor,
        ),
        title: showText
            ? Text(
                item['title'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: fontNunitoSans,
                  color: activeRoute == item['route']
                      ? Colors.blue
                      : secondaryTextColor,
                ),
              )
            : null,
        onTap: () {
          setState(() {
            activeRoute = item['route'] as String;
          });
          Navigator.pushNamed(context, activeRoute);
        },
      );
    }).toList();
  }
}
