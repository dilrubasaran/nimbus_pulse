import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(
        child: Text(
          "Login Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
