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
  bool _isLoading = true;
  String? _error;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // TODO: Get actual user ID from auth service
      const String userId = "7";
      final profileData = await _settingsService.getProfile(userId);

      setState(() {
        _nameController.text = profileData.firstName;
        _surnameController.text = profileData.surName;
        _emailController.text = profileData.email;
        _phoneController.text = profileData.phoneNumber;
        _profilePictureUrl = profileData.profilePictureUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil bilgileri yüklenirken hata oluştu: $_error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Sabit kullanıcı ID'si
      const String userId = "7";

      final profileData = ProfileUpdateDTO(
        firstName: _nameController.text,
        surName: _surnameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        profilePictureUrl: _profilePictureUrl,
      );

      final success = await _settingsService.updateProfile(userId, profileData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil başarıyla güncellendi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil güncellenirken hata oluştu: $_error'),
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
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  controller:
                                                      _surnameController,
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
                                                        color:
                                                            Color(0xFF177EC6)),
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
                                          onPressed:
                                              _isLoading ? null : _saveChanges,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF177EC6),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 32,
                                              vertical: 16,
                                            ),
                                          ),
                                          child: Text(
                                            'Değişiklikleri Kaydet',
                                            style:
                                                TextStyle(color: Colors.white),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
