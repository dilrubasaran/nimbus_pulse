import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';
import 'package:nimbus_pulse/pages/settings/settings_header.dart';

class SettingsThemeLanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Row(children: [
        SettingsHeader(
          currentTab: 'Tema',
        ),
        Text(
          "Theme Page",
          style: TextStyle(fontSize: 24),
        ),
      ]),
    );
  }
}
