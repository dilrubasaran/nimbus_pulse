import 'package:flutter/material.dart';
import 'package:nimbus_pulse/pages/dashboard_home.dart';
import 'package:nimbus_pulse/pages/settings/settings_password.dart';
import 'package:nimbus_pulse/pages/settings/settings_profile.dart';
import 'package:nimbus_pulse/pages/settings/settings_security.dart';
import 'package:nimbus_pulse/pages/settings/settings_theme_language.dart';
import 'navigation/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Nunito Sans",
        scaffoldBackgroundColor: (Colors.white10),
      ),
      initialRoute: '/settings/setting_profile',
      routes: {
        '/dashboard': (context) => DashboardHome(),
        '/settings/setting_profile': (context) => SettingsProfilePage(),
        '/settings/setting_password': (context) => SettingsPasswordPage(),
        '/settings/setting_theme_language': (context) =>
            SettingsThemeLanguagePage(),
        '/settings/setting_security': (context) => SettingsSecurityPage(),
      },
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
