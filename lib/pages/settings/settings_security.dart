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
  final _userSettingsService = UserSettingsService(DioClient());

  String _currentSecurityCode = '';
  String _newSecurityCode = '';
  String _confirmNewSecurityCode = '';
  String _phoneNumber = '';
  String _smsCode = '';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _updateSecurityCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _userSettingsService.updateSecurityCode(
        '1', // TODO: Get actual user ID
        SecurityCodeChangeDTO(
          currentSecurityCode: _currentSecurityCode,
          newSecurityCode: _newSecurityCode,
          confirmNewSecurityCode: _confirmNewSecurityCode,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Güvenlik kodu başarıyla güncellendi'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _currentSecurityCode = '';
        _newSecurityCode = '';
        _confirmNewSecurityCode = '';
        _formKey.currentState?.reset();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage ?? 'Bir hata oluştu'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateSecurityCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alan zorunludur';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'Güvenlik kodu 4 haneli olmalıdır';
    }
    return null;
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingsHeader(currentTab: 'Güvenlik Kodu'),
                        SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Güvenlik Kodu Bölümü
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
                                      onChanged: (value) =>
                                          _currentSecurityCode = value,
                                      validator: _validateSecurityCode,
                                    ),
                                    SizedBox(height: 16),
                                    SecurityInputField(
                                      title: "Yeni Güvenlik Kodu:",
                                      onChanged: (value) =>
                                          _newSecurityCode = value,
                                      validator: _validateSecurityCode,
                                    ),
                                    SizedBox(height: 24),
                                    if (_errorMessage != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Text(
                                          _errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      width: 200,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: _isLoading
                                            ? null
                                            : _updateSecurityCode,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF177EC6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: _isLoading
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                "Değişiklikleri Kaydet",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'NunitoSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),
                              // SMS Doğrulama Bölümü
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SMS ile Doğrulama',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF177EC6),
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    SecurityInputField(
                                      title: "Telefon:",
                                      onChanged: (value) =>
                                          _phoneNumber = value,
                                      validator: null,
                                      obscureText: false,
                                    ),
                                    SizedBox(height: 16),
                                    SizedBox(
                                      width: 150,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // TODO: SMS Kodu Gönder
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF177EC6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Kodu Gönder",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'NunitoSans',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    SecurityInputField(
                                      title: "SMS Kodu:",
                                      onChanged: (value) => _smsCode = value,
                                      validator: null,
                                    ),
                                    SizedBox(height: 24),
                                    SizedBox(
                                      width: 200,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // TODO: SMS ile doğrulama
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF177EC6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Değişiklikleri Kaydet",
                                          style: TextStyle(
                                            fontSize: 14,
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

class SecurityInputField extends StatelessWidget {
  final String title;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;

  const SecurityInputField({
    required this.title,
    required this.onChanged,
    this.validator,
    this.obscureText = true,
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
            fontFamily: 'NunitoSans',
            color: Color(0xFF177EC6),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 45,
          child: TextFormField(
            obscureText: obscureText,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFEFF8FF),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            ),
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'NunitoSans',
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
      ],
    );
  }
}
