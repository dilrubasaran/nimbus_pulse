import 'package:flutter/material.dart';
import 'package:nimbus_pulse/styles/consts.dart';
import '../../layout/sidebar.dart';
import '../../layout/header.dart';
import '../../services/user_settings_service.dart';
import '../../dtos/settings_dto.dart';
import '../../core/network/dio_client.dart';

import 'settings_header.dart';

class SettingsProfilePage extends StatefulWidget {
  @override
  _SettingsProfilePageState createState() => _SettingsProfilePageState();
}

class _SettingsProfilePageState extends State<SettingsProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final UserSettingsService _settingsService = UserSettingsService(DioClient());
  bool _isSaving = false;
  String? _error;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _profilePictureUrl = '';

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isSaving = true;
        _error = null;
      });

      // TODO: Get actual user ID from auth service
      const String userId = "7";

      final profileData = ProfileUpdateDTO(
        firstName: _nameController.text,
        surName: _surnameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        profilePictureUrl: _profilePictureUrl,
      );

      final success = await _settingsService.updateProfile(userId, profileData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil başarıyla güncellendi'),
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
            content: Text('Profil güncellenirken hata oluştu: $_error'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Tekrar Dene',
              textColor: Colors.white,
              onPressed: _saveChanges,
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Sidebar(currentRoute: '/settings/settings_profile'),
            Expanded(
              child: Column(
                children: [
                  Header(title: 'Profil'),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SettingsHeader(currentTab: 'Profil'),
                            SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 124, 124, 124)
                                            .withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 2,
                                        ),
                                        image: _profilePictureUrl.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    _profilePictureUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: _profilePictureUrl.isEmpty
                                          ? Icon(
                                              Icons.person,
                                              size: 20,
                                              color: Colors.blue,
                                            )
                                          : null,
                                    ),
                                    SizedBox(height: 12),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        // TODO: Implement profile picture upload
                                      },
                                      icon:
                                          Icon(Icons.upload_outlined, size: 16),
                                      label: Text('Fotoğraf Yükle'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                        side: BorderSide(color: Colors.blue),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    _buildTextField(
                                      label: 'Ad',
                                      controller: _nameController,
                                      prefixIcon: Icons.person_outline,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ad alanı boş bırakılamaz';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Soyad',
                                      controller: _surnameController,
                                      prefixIcon: Icons.person_outline,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Soyad alanı boş bırakılamaz';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'E-posta',
                                      controller: _emailController,
                                      prefixIcon: Icons.email_outlined,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'E-posta alanı boş bırakılamaz';
                                        }
                                        if (!value.contains('@')) {
                                          return 'Geçerli bir e-posta adresi giriniz';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Telefon',
                                      controller: _phoneController,
                                      prefixIcon: Icons.phone_outlined,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Telefon alanı boş bırakılamaz';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed:
                                            _isSaving ? null : _saveChanges,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: bgPrimaryColor,
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
