import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/register_service.dart';
import '../dtos/register_dto.dart';
import '../core/network/dio_client.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
      ),
      filled: true,
      fillColor: Color(0xFFEFF8FF),
      prefixIcon: Icon(
        prefixIcon,
        color: Colors.grey[400],
      ),
      suffixIcon: suffixIcon,
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
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
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
          obscureText: isPassword && obscureText,
          decoration: _buildInputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final registerDTO = RegisterDTO(
          name: _firstNameController.text,
          surname: _lastNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          companyName: _companyController.text,
          password: _passwordController.text,
        );

        final registerService = RegisterService(DioClient());
        final success = await registerService.register(registerDTO);

        if (success) {
          Navigator.pushReplacementNamed(context, '/server');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring('Exception: '.length);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nimbuspulse_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxWidth = constraints.maxWidth;
                  double cardWidth = maxWidth > 1200
                      ? 1000
                      : maxWidth > 900
                          ? maxWidth * 0.7
                          : maxWidth > 600
                              ? maxWidth * 0.8
                              : maxWidth * 0.9;

                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(
                      horizontal:
                          maxWidth > 600 ? (maxWidth - cardWidth) / 2 : 20,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: cardWidth,
                      padding: EdgeInsets.all(maxWidth > 600 ? 32.0 : 20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 216, 236, 253),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/images/nimbuspulse_logo.svg',
                              height: 80,
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Create an Account',
                              style: TextStyle(
                                fontSize: maxWidth > 600 ? 28 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            GridView.count(
                              crossAxisCount: maxWidth > 1200 ? 2 : 1,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: maxWidth > 1200
                                  ? 4
                                  : maxWidth > 900
                                      ? 3.5
                                      : maxWidth > 600
                                          ? 3
                                          : 3.5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 6,
                              children: [
                                _buildTextField(
                                  label: 'First Name',
                                  controller: _firstNameController,
                                  hintText: 'Enter your first name',
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  label: 'Last Name',
                                  controller: _lastNameController,
                                  hintText: 'Enter your last name',
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your last name';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  label: 'Email',
                                  controller: _emailController,
                                  hintText: 'example@company.com',
                                  prefixIcon: Icons.email_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  label: 'Phone Number',
                                  controller: _phoneController,
                                  hintText: '530 555 55 55',
                                  prefixIcon: Icons.phone_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  label: 'Company Name',
                                  controller: _companyController,
                                  hintText: 'Enter your company name',
                                  prefixIcon: Icons.business_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your company name';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  label: 'Password',
                                  controller: _passwordController,
                                  hintText: 'Enter your password',
                                  prefixIcon: Icons.lock_outline,
                                  isPassword: true,
                                  obscureText: _obscurePassword,
                                  onTogglePassword: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  label: 'Confirm Password',
                                  controller: _confirmPasswordController,
                                  hintText: 'Confirm your password',
                                  prefixIcon: Icons.lock_outline,
                                  isPassword: true,
                                  obscureText: _obscureConfirmPassword,
                                  onTogglePassword: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value!;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                Expanded(
                                  child: Text(
                                    'I accept terms and conditions',
                                    style: TextStyle(
                                      fontSize: maxWidth > 600 ? 14 : 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _acceptTerms ? _register : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: maxWidth > 600 ? 18 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontSize: maxWidth > 600 ? 14 : 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: maxWidth > 600 ? 14 : 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
