import 'package:flutter/material.dart';
import 'package:nimbus_pulse/pages/server.dart';
import 'package:nimbus_pulse/pages/device_detail.dart';
import 'package:nimbus_pulse/pages/login.dart';
import 'package:nimbus_pulse/pages/register.dart';
import 'package:nimbus_pulse/pages/dashboard.dart';
import 'package:nimbus_pulse/pages/reports.dart';
import 'package:nimbus_pulse/pages/settings/settings_profile.dart';
import 'package:nimbus_pulse/pages/settings/settings_password.dart';
import 'package:nimbus_pulse/pages/settings/settings_theme_language.dart';
import 'package:nimbus_pulse/pages/settings/settings_security.dart';
import '../pages/dashboard.dart';
import '../pages/server.dart';
import '../pages/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('\n=== Route Navigation ===');
    print('Route: ${settings.name}');
    print('Arguments: ${settings.arguments}');

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ServerPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());

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

      case '/dashboard':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('deviceId')) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('Error: Device ID not provided'),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => Dashboard(),
          settings: settings,
        );

      case '/server':
        return MaterialPageRoute(builder: (_) => ServerPage());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}
