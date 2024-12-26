import 'package:flutter/material.dart';
import 'package:nimbus_pulse/pages/dashboard_home.dart';
import 'package:nimbus_pulse/pages/device_detail.dart';
import 'package:nimbus_pulse/pages/login.dart';
import 'package:nimbus_pulse/pages/register.dart';
import 'package:nimbus_pulse/pages/server.dart';
import 'package:nimbus_pulse/pages/reports.dart';
import 'package:nimbus_pulse/pages/settings/settings_profile.dart';
import 'package:nimbus_pulse/pages/settings/settings_password.dart';
import 'package:nimbus_pulse/pages/settings/settings_theme_language.dart';
import 'package:nimbus_pulse/pages/settings/settings_security.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
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
      case '/device_detail':
        final args = settings.arguments as Map<String, String>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => DeviceDetailPage(
              deviceId: args['deviceId']!,
              deviceName: args['deviceName']!,
            ),
          );
        }
        return _errorRoute();
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text('Hata')),
            body: Center(child: Text('Sayfa bulunamadı')),
          ),
        );
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Hata')),
        body: Center(child: Text('Sayfa bulunamadı')),
      ),
    );
  }
}
