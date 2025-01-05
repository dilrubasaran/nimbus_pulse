import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';
import 'package:nimbus_pulse/pages/settings/settings_header.dart';
import 'package:nimbus_pulse/services/user_settings_service.dart';
import 'package:nimbus_pulse/dtos/settings_dto.dart';
import 'package:nimbus_pulse/core/network/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:nimbus_pulse/providers/theme_provider.dart';

class SettingsThemeLanguagePage extends StatefulWidget {
  @override
  _SettingsThemeLanguagePageState createState() =>
      _SettingsThemeLanguagePageState();
}

class _SettingsThemeLanguagePageState extends State<SettingsThemeLanguagePage> {
  final UserSettingsService _settingsService = UserSettingsService(DioClient());
  bool _isSaving = false;
  String _selectedTheme = 'system'; // system, light, dark
  String _selectedLanguage = 'tr'; // tr, en
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    try {
      // TODO: Get actual user ID from auth service
      const String userId = "7";
      final settings = await _settingsService.getThemeSettings(userId);
      setState(() {
        _selectedTheme = settings.theme;
        _selectedLanguage = settings.language;
      });
      _updateAppTheme(_selectedTheme);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tema ayarları yüklenirken hata oluştu: $_error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateAppTheme(String theme) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    switch (theme) {
      case 'dark':
        themeProvider.setThemeMode(ThemeMode.dark);
        break;
      case 'light':
        themeProvider.setThemeMode(ThemeMode.light);
        break;
      default:
        themeProvider.setThemeMode(ThemeMode.system);
    }
  }

  Future<void> _saveThemeSettings() async {
    try {
      setState(() {
        _isSaving = true;
        _error = null;
      });

      _updateAppTheme(_selectedTheme);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tema başarıyla güncellendi'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tema güncellenirken hata oluştu: $_error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildThemeOption(String title, String value, String imagePath) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTheme = value;
          });
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF2D2D2D) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _selectedTheme == value
                  ? Color(0xFF177EC6)
                  : Color(0xFFD9D9D9),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: _selectedTheme == value
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedTheme == value
                      ? Color(0xFF177EC6)
                      : (isDark ? Colors.white70 : Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dil Seçenekleri:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF177EC6),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF2D2D2D) : Color(0xFFEFF8FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isDark ? Color(0xFF404040) : Color(0xFFD9D9D9)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF177EC6)),
              dropdownColor: isDark ? Color(0xFF2D2D2D) : Colors.white,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Color(0xFF2D2D2D),
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'tr',
                  child: Row(
                    children: [
                      Image.asset('assets/images/tr_flag.png',
                          width: 24, height: 24),
                      SizedBox(width: 8),
                      Text(
                        'Türkçe',
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF2D2D2D),
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      Image.asset('assets/images/en_flag.png',
                          width: 24, height: 24),
                      SizedBox(width: 8),
                      Text(
                        'English',
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF2D2D2D),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsHeader(currentTab: 'Tema'),
              SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tema Seçenekleri:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF177EC6),
                        ),
                      ),
                      SizedBox(height: 24),
                      Column(
                        children: [
                          _buildThemeOption(
                            'Sistem Teması',
                            'system',
                            'assets/images/theme_system.png',
                          ),
                          SizedBox(height: 16),
                          _buildThemeOption(
                            'Açık Tema',
                            'light',
                            'assets/images/theme_light.png',
                          ),
                          SizedBox(height: 16),
                          _buildThemeOption(
                            'Koyu Tema',
                            'dark',
                            'assets/images/theme_dark.png',
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      _buildLanguageDropdown(),
                      SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveThemeSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF177EC6),
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: _isSaving
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Kaydediliyor...'),
                                  ],
                                )
                              : Text('Değişiklikleri Kaydet'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
