import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/header.dart';
import 'package:nimbus_pulse/layout/sidebar.dart';
import 'package:nimbus_pulse/pages/settings/settings_header.dart';

class SettingsPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(),
          Expanded(
            child: Column(
              children: [
                // Header
                Header(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Settings Header
                        SettingsHeader(
                          currentTab: 'Password',
                        ),
                        SizedBox(height: 24),
                        // Password Change Form
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileInputField(
                                title: "Mevcut Şifre:",
                                initialValue: "",
                                obscureText: true,
                              ),
                              SizedBox(height: 16),
                              ProfileInputField(
                                title: "Yeni Şifre:",
                                initialValue: "",
                                obscureText: true,
                              ),
                              SizedBox(height: 16),
                              ProfileInputField(
                                title: "Yeni Şifre Tekrar:",
                                initialValue: "",
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                        // Save Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle save changes
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF177EC6),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Şifreyi Güncelle",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'NunitoSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInputField extends StatelessWidget {
  final String title;
  final String initialValue;
  final bool obscureText;

  const ProfileInputField({
    required this.title,
    required this.initialValue,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'NunitoSans',
            color: Color(0xFF177EC6),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFEFF8FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
            ),
          ),
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'NunitoSans',
            color: Color(0xFFA3A3A3),
          ),
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;

  const TabButton({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: () {
          // Handle tab click
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'NunitoSans',
            color: isSelected ? Color(0xFF177EC6) : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
