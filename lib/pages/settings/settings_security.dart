import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/header.dart';
import 'package:nimbus_pulse/layout/sidebar.dart';
import 'package:nimbus_pulse/pages/settings/settings_header.dart';

class SettingsSecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(currentRoute: '/settings/settings_security'),
          Expanded(
            child: Column(
              children: [
                // Header
                Header(title: 'Güvenlik Kodu'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Settings Header
                        SettingsHeader(
                          currentTab: 'Güvenlik Kodu',
                        ),
                        SizedBox(height: 24),
                        // Form Bölgesi
                        Expanded(
                          child: Row(
                            children: [
                              // Sol Form: Mevcut ve Yeni Güvenlik Kodu
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProfileInputField(
                                      title: "Mevcut Güvenlik Kodu:",
                                      initialValue: "",
                                      obscureText: true,
                                    ),
                                    SizedBox(height: 16),
                                    ProfileInputField(
                                      title: "Yeni Güvenlik Kodu:",
                                      initialValue: "",
                                      obscureText: true,
                                    ),
                                    SizedBox(height: 24),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Mevcut güvenlik kodu kaydet
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF177EC6),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Değişiklikleri Kaydet",
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
                              // Orta Bölme
                              VerticalDivider(
                                color: Color(0xFFD9D9D9),
                                thickness: 1,
                                width: 32,
                              ),
                              // Sağ Form: Telefon ve SMS Doğrulama
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProfileInputField(
                                      title: "Telefon:",
                                      initialValue: "",
                                      obscureText: false,
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        // SMS Kodu Gönder
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF177EC6),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        "Kodu Gönder",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'NunitoSans',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    ProfileInputField(
                                      title: "Yeni Güvenlik Kodu:",
                                      initialValue: "",
                                      obscureText: true,
                                    ),
                                    SizedBox(height: 24),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Telefon ile kaydet
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF177EC6),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Değişiklikleri Kaydet",
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
                            ],
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
