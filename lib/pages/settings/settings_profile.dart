import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/header.dart';
import 'package:nimbus_pulse/layout/sidebar.dart';
import 'package:nimbus_pulse/pages/settings/settings_header.dart';

class SettingsProfilePage extends StatelessWidget {
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
                          currentTab: 'Profil',
                        ),
                        SizedBox(height: 24),
                        // Profile Form
                        Expanded(
                          child: Row(
                            children: [
                              // Left Form
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProfileInputField(
                                        title: "Ad Soyad:",
                                        initialValue: "Dilruba Başaran"),
                                    SizedBox(height: 16),
                                    ProfileInputField(
                                        title: "Şirket Adı:",
                                        initialValue: "X Yazılım"),
                                    SizedBox(height: 16),
                                    ProfileInputField(
                                        title: "E-mail:",
                                        initialValue: "example123@gmail.com"),
                                    SizedBox(height: 16),
                                    ProfileInputField(
                                        title: "Telefon:",
                                        initialValue: "05 -- -- -- --"),
                                  ],
                                ),
                              ),
                              // Right Section (Profile Picture)
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile_picture.jpg'),
                                    ),
                                    SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () {
                                        // Handle profile photo upload
                                      },
                                      child: Text(
                                        "Profil fotoğrafı yükle, değiştir",
                                        style: TextStyle(
                                          color: Color(0xFF177EC6),
                                          fontSize: 12,
                                          fontFamily: 'NunitoSans',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

  const ProfileInputField({
    required this.title,
    required this.initialValue,
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
