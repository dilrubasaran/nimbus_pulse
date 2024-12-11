import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';

class ServerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(
        child: Text(
          "Server Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
