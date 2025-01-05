import 'package:flutter/material.dart';
import '../../layout/sidebar.dart';
import '../../layout/header.dart';
import '../../services/user_settings_service.dart';
import '../../dtos/settings_dto.dart';
import '../../core/network/dio_client.dart';
import 'settings_header.dart';

class SettingsPasswordPage extends StatefulWidget {
  @override
  _SettingsPasswordPageState createState() => _SettingsPasswordPageState();
}

class _SettingsPasswordPageState extends State<SettingsPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final UserSettingsService _settingsService = UserSettingsService(DioClient());
  bool _isLoading = false;
  String? _error;

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Sabit kullanıcı ID'si
      const String userId = "7";

      final passwordData = PasswordChangeDTO(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
      );

      final success =
          await _settingsService.updatePassword(userId, passwordData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Şifre başarıyla güncellendi'),
            backgroundColor: Colors.green,
          ),
        );
        // Clear form after successful update
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Şifre güncellenirken hata oluştu: $_error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Sidebar(currentRoute: '/settings/settings_password'),
            Expanded(
              child: Column(
                children: [
                  Header(title: 'Şifre'),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SettingsHeader(currentTab: 'Şifre'),
                          SizedBox(height: 32),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPasswordField(
                                  label: 'Mevcut Şifre',
                                  controller: _currentPasswordController,
                                  isVisible: _currentPasswordVisible,
                                  onVisibilityToggle: () {
                                    setState(() {
                                      _currentPasswordVisible =
                                          !_currentPasswordVisible;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mevcut şifre alanı boş bırakılamaz';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24),
                                _buildPasswordField(
                                  label: 'Yeni Şifre',
                                  controller: _newPasswordController,
                                  isVisible: _newPasswordVisible,
                                  onVisibilityToggle: () {
                                    setState(() {
                                      _newPasswordVisible =
                                          !_newPasswordVisible;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Yeni şifre alanı boş bırakılamaz';
                                    }
                                    if (value.length < 6) {
                                      return 'Şifre en az 6 karakter olmalıdır';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24),
                                _buildPasswordField(
                                  label: 'Yeni Şifre (Tekrar)',
                                  controller: _confirmPasswordController,
                                  isVisible: _confirmPasswordVisible,
                                  onVisibilityToggle: () {
                                    setState(() {
                                      _confirmPasswordVisible =
                                          !_confirmPasswordVisible;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Şifre tekrar alanı boş bırakılamaz';
                                    }
                                    if (value != _newPasswordController.text) {
                                      return 'Şifreler eşleşmiyor';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 32),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _changePassword,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF177EC6),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 16,
                                      ),
                                    ),
                                    child: Text(
                                      'Şifreyi Güncelle',
                                      style: TextStyle(color: Colors.white),
                                    ),
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
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isVisible = false,
    required VoidCallback onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF177EC6),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: isVisible,
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
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFF177EC6),
              ),
              onPressed: onVisibilityToggle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
