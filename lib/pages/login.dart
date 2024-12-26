import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:nimbus_pulse/services/user_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

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
                    ? 600
                    : maxWidth > 900
                        ? maxWidth * 0.5
                        : maxWidth > 600
                            ? maxWidth * 0.7
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
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: maxWidth > 600 ? 28 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),
                          _buildTextField(
                            'E-mail address or username:',
                            _emailController,
                            'example123@gmail.com',
                          ),
                          SizedBox(height: 24),
                          _buildTextField(
                            'Password:',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Implement forgot password
                                },
                                child: Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: maxWidth > 600 ? 14 : 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Remember Me
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              Text(
                                'Remember Me',
                                style: TextStyle(
                                  fontSize: maxWidth > 600 ? 14 : 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _login,
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: maxWidth > 600 ? 18 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: maxWidth > 600 ? 14 : 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/register');
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: maxWidth > 600 ? 14 : 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Or divider
                          Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Or',
                                  style: TextStyle(
                                    fontSize: maxWidth > 600 ? 14 : 12,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Google Sign In Button
                          OutlinedButton.icon(
                            onPressed: () {
                              // Implement Google Sign In
                            },
                            icon: Icon(Icons.g_mobiledata, size: 24),
                            label: Text(
                              'Sign up with Google',
                              style: TextStyle(
                                fontSize: maxWidth > 600 ? 14 : 12,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
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
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: onTogglePassword,
                      ),
                      if (suffix != null) suffix,
                    ],
                  )
                : suffix,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Direkt dashboard'a git
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
