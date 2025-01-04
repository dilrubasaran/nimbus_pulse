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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                int crossAxisCount = maxWidth > 1200 ? 2 : 1;

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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Logo
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
                          SizedBox(height: 32),
                          // Form Fields in Grid
                          GridView.count(
                            crossAxisCount: crossAxisCount,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            childAspectRatio: maxWidth > 1200
                                ? 4
                                : maxWidth > 900
                                    ? 3.5
                                    : maxWidth > 600
                                        ? 3
                                        : 2.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: [
                              _buildTextField(
                                'First Name',
                                _firstNameController,
                                'Enter your first name',
                              ),
                              _buildTextField(
                                'Last Name',
                                _lastNameController,
                                'Enter your last name',
                              ),
                              _buildTextField(
                                'Email',
                                _emailController,
                                'example@company.com',
                                isEmail: true,
                              ),
                              _buildTextField(
                                'Phone Number',
                                _phoneController,
                                '530 555 55 55',
                              ),
                              _buildTextField(
                                'Company Name',
                                _companyController,
                                'Enter your company name',
                              ),
                              _buildTextField(
                                'Password',
                                _passwordController,
                                'Enter your password',
                                isPassword: true,
                                obscureText: _obscurePassword,
                                onTogglePassword: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              _buildTextField(
                                'Confirm Password',
                                _confirmPasswordController,
                                'Confirm your password',
                                isPassword: true,
                                obscureText: _obscureConfirmPassword,
                                onTogglePassword: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          // Terms and Conditions
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerms = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  'I accept terms and conditions',
                                  style: TextStyle(
                                    fontSize: maxWidth > 600 ? 14 : 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),

                          // Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _acceptTerms ? _register : null,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: maxWidth > 600 ? 18 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: maxWidth > 600 ? 14 : 12,
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
    bool isEmail = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            if (isEmail && !value.contains('@')) {
              return 'Please enter a valid email';
            }
            if (isPassword && value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
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
        print('\nPreparing registration data...');
        final registerDTO = RegisterDTO(
          name: _firstNameController.text,
          surname: _lastNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          companyName: _companyController.text,
          password: _passwordController.text,
        );

        print('Creating RegisterService...');
        final registerService = RegisterService(DioClient());

        print('Calling register method...');
        final success = await registerService.register(registerDTO);
        print('Register method returned: $success');

        if (success) {
          print('Registration successful, navigating to server page...');
          Navigator.pushReplacementNamed(context, '/server');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print('Registration error caught: $e');
        String errorMessage = e.toString();
        // "Exception: " prefix'ini kaldır
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
