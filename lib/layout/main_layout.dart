import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/header.dart';
import 'package:nimbus_pulse/layout/sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget body;

  const MainLayout({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
              currentRoute:
                  ModalRoute.of(context)?.settings.name ?? '/dashboard'),
          Expanded(
            child: Column(
              children: [
                Header(
                    title: _getPageTitle(
                        ModalRoute.of(context)?.settings.name ?? '/dashboard')),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(String route) {
    switch (route) {
      case '/dashboard':
        return 'Dashboard';
      case '/device_detail':
        return 'Device Detail';
      case '/settings/settings_profile':
        return 'Profile Settings';
      case '/settings/settings_password':
        return 'Password Settings';
      case '/settings/settings_theme':
        return 'Theme Settings';
      case '/settings/settings_security_code':
        return 'Security Code Settings';
      default:
        return 'Dashboard';
    }
  }
}
