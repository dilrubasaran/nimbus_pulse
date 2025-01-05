import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/header.dart';
import 'package:nimbus_pulse/layout/sidebar.dart';
import 'package:nimbus_pulse/pages/settings/settings_header.dart';
import 'package:nimbus_pulse/services/user_settings_service.dart';
import 'package:nimbus_pulse/dtos/settings_dto.dart';
import 'package:nimbus_pulse/core/network/dio_client.dart';

class SettingsSecurityPage extends StatefulWidget {
  @override
  _SettingsSecurityPageState createState() => _SettingsSecurityPageState();
}

class _SettingsSecurityPageState extends State<SettingsSecurityPage> {
  final _formKey = GlobalKey<FormState>();
  final UserSettingsService _settingsService = UserSettingsService(DioClient());
  bool _isSaving = false;
  String? _error;

  final TextEditingController _currentSecurityCodeController =
      TextEditingController();
  final TextEditingController _newSecurityCodeController =
      TextEditingController();
  final TextEditingController _confirmSecurityCodeController =
      TextEditingController();

  String? _validateSecurityCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alan zorunludur';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'Güvenlik kodu 4 haneli olmalıdır';
    }
    return null;
  }

  String? _validateConfirmSecurityCode(String? value) {
    final codeError = _validateSecurityCode(value);
    if (codeError != null) return codeError;

    if (value != _newSecurityCodeController.text) {
      return 'Güvenlik kodları eşleşmiyor';
    }
    return null;
  }

  Future<void> _updateSecurityCode() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isSaving = true;
        _error = null;
      });

      // TODO: Get actual user ID from auth service
      const String userId = "9";

      final securityData = SecurityCodeChangeDTO(
        currentSecurityCode: _currentSecurityCodeController.text,
        newSecurityCode: _newSecurityCodeController.text,
        confirmNewSecurityCode: _confirmSecurityCodeController.text,
      );

      if (!securityData.isValid()) {
        setState(() {
          _error = 'Lütfen tüm alanları doğru formatta doldurun';
        });
        return;
      }

      final success =
          await _settingsService.updateSecurityCode(userId, securityData);

      if (success && mounted) {
        // Başarılı durumda form alanlarını temizle
        _currentSecurityCodeController.clear();
        _newSecurityCodeController.clear();
        _confirmSecurityCodeController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Güvenlik kodu başarıyla güncellendi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Güvenlik kodu güncellenirken hata oluştu: $_error'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Tekrar Dene',
              textColor: Colors.white,
              onPressed: _updateSecurityCode,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentRoute: '/settings/settings_security'),
          Expanded(
            child: Column(
              children: [
                Header(title: 'Güvenlik Kodu'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingsHeader(currentTab: 'Güvenlik Kodu'),
                        SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFD9D9D9),
                              width: 1,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Güvenlik Kodu Değiştir',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF177EC6),
                                  ),
                                ),
                                SizedBox(height: 24),
                                SecurityInputField(
                                  title: "Mevcut Güvenlik Kodu:",
                                  controller: _currentSecurityCodeController,
                                  validator: _validateSecurityCode,
                                ),
                                SizedBox(height: 16),
                                SecurityInputField(
                                  title: "Yeni Güvenlik Kodu:",
                                  controller: _newSecurityCodeController,
                                  validator: _validateSecurityCode,
                                ),
                                SizedBox(height: 16),
                                SecurityInputField(
                                  title: "Yeni Güvenlik Kodu (Tekrar):",
                                  controller: _confirmSecurityCodeController,
                                  validator: _validateConfirmSecurityCode,
                                ),
                                if (_error != null) ...[
                                  SizedBox(height: 16),
                                  Text(
                                    _error!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                SizedBox(height: 24),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 200,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: _isSaving
                                          ? null
                                          : _updateSecurityCode,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF177EC6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: _isSaving
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentSecurityCodeController.dispose();
    _newSecurityCodeController.dispose();
    _confirmSecurityCodeController.dispose();
    super.dispose();
  }
}

class SecurityInputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const SecurityInputField({
    required this.title,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF177EC6),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFEFF8FF),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }
}
