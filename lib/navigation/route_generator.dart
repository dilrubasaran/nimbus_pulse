import 'package:flutter/material.dart';
import 'package:nimbus_pulse/pages/settings/settings_security.dart';
import 'package:nimbus_pulse/pages/settings/settings_theme_language.dart';
import '../pages/dashboard_home.dart';
import '../pages/server.dart';
import '../pages/reports.dart';
import '../pages/settings/settings_profile.dart';
import '../pages/settings/settings_password.dart';
import '../pages/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => DashboardHome());
      case '/server':
        return MaterialPageRoute(builder: (_) => ServerPage());
      case '/reports':
        return MaterialPageRoute(builder: (_) => ReportsPage());
      case '/settings/settings_profile':
        return MaterialPageRoute(builder: (_) => SettingsProfilePage());
      case '/settings/settings_password':
        return MaterialPageRoute(builder: (_) => SettingsPasswordPage());
      case '/settings/settings_theme_language':
        return MaterialPageRoute(builder: (_) => SettingsThemeLanguagePage());
      case '/settings/settings_security':
        return MaterialPageRoute(builder: (_) => SettingsSecurityPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text('Hata')),
            body: Center(child: Text('Sayfa bulunamadı')),
          ),
        );
    }
  }
}
