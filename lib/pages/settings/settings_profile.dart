import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: Row(
          children: [
            Sidebar(currentRoute: '/settings/settings_profile'),
            Expanded(
              child: Column(
                children: [
                  Header(title: 'Profil'),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SettingsHeader(currentTab: 'Profil'),
                          SizedBox(height: 32),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          _buildTextField(
                                            label: 'Ad',
                                            controller: _nameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ad alanı boş bırakılamaz';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 16),
                                          _buildTextField(
                                            label: 'Soyad',
                                            controller: _surnameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Soyad alanı boş bırakılamaz';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 16),
                                          _buildTextField(
                                            label: 'E-posta',
                                            controller: _emailController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'E-posta alanı boş bırakılamaz';
                                              }
                                              if (!RegExp(
                                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                  .hasMatch(value)) {
                                                return 'Geçerli bir e-posta adresi giriniz';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 16),
                                          _buildTextField(
                                            label: 'Telefon',
                                            controller: _phoneController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Telefon alanı boş bırakılamaz';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 32),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundImage: _profilePictureUrl
                                                    .isNotEmpty
                                                ? NetworkImage(
                                                    _profilePictureUrl)
                                                : AssetImage(
                                                        'assets/images/profile_picture.jpg')
                                                    as ImageProvider,
                                          ),
                                          SizedBox(height: 16),
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Implement profile picture upload
                                            },
                                            child: Text(
                                              'Profil fotoğrafı yükle',
                                              style: TextStyle(
                                                  color: Color(0xFF177EC6)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 32),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: _isSaving ? null : _saveChanges,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
