import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(
        child: Text(
          "Repots Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
