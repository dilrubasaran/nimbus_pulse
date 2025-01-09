import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';
import 'package:nimbus_pulse/pages/settings/settings_header.dart';
import 'package:nimbus_pulse/services/user_settings_service.dart';
import 'package:nimbus_pulse/core/network/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:nimbus_pulse/providers/theme_provider.dart';
import 'package:nimbus_pulse/styles/consts.dart';
import 'package:nimbus_pulse/layout/header.dart';

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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = _selectedTheme == value;

    return Container(
      width: double.infinity,
      height: 80,
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? primaryTextColor : Color(0xFFE2E8F0),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTheme = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : primaryTextColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Radio(
                value: value,
                groupValue: _selectedTheme,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTheme = newValue;
                    });
                  }
                },
                activeColor: primaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dil Seçenekleri:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: bgPrimaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: primaryTextColor),
                dropdownColor: isDark ? Color(0xFF1E293B) : backgroundColor,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : primaryTextColor,
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
                            color: isDark ? Colors.white : primaryTextColor,
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
                            color: isDark ? Colors.white : primaryTextColor,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: SafeArea(
        child: Column(
          children: [
            Header(title: 'Tema'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsHeader(currentTab: 'Tema'),
                    SizedBox(height: 24),
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
                                color: primaryTextColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            _buildThemeOption(
                              'Açık Tema',
                              'light',
                              'assets/images/theme_light.png',
                            ),
                            SizedBox(height: 8),
                            _buildThemeOption(
                              'Koyu Tema',
                              'dark',
                              'assets/images/theme_dark.png',
                            ),
                            SizedBox(height: 24),
                            _buildLanguageDropdown(),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed:
                                    _isSaving ? null : _saveThemeSettings,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryTextColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                                child: _isSaving
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    : Text(
                                        'Değişiklikleri Kaydet',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
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
            ),
          ],
        ),
      ),
    );
  }
}
