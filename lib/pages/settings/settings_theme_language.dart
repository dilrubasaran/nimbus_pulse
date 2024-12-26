import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';
import 'package:nimbus_pulse/pages/settings/settings_header.dart';

class SettingsThemeLanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsHeader(
              currentTab: 'Tema',
            ),
            SizedBox(height: 24),
            Text(
              "Theme Page",
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
