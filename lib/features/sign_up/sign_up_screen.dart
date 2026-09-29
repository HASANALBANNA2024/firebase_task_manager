import 'package:firebase_task_manager/core/widgets/app_button.dart';
import 'package:firebase_task_manager/core/widgets/app_logo.dart';
import 'package:firebase_task_manager/core/widgets/app_message.dart';
import 'package:firebase_task_manager/core/widgets/app_text_field.dart';
import 'package:firebase_task_manager/firebase/authentication/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B132B), Color(0xFF0B2D39), Color(0xFF042421)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// back button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 16),

                /// reusable logo
                const AppLogo(size: 60, iconSize: 32),
                const SizedBox(height: 24),

                /// title
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign up to start planning and syncing your tasks.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 32),

                /// email field
                AppTextField(
                  controller: _emailController,
                  labelText: "Email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                /// password field
                AppTextField(
                  controller: _passwordController,
                  labelText: "Password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                /// confirm password filed
                AppTextField(
                  controller: _confirmPasswordController,
                  labelText: "Confirm Password",
                  prefixIcon: Icons.lock_reset_outlined,
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                /// sign up button
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00BFA5),
                        ),
                      )
                    : AppButton(
                        text: "Sign Up",
                        onPressed: () async {
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String confirmPassword = _confirmPasswordController
                              .text
                              .trim();

                          if (email.isEmpty ||
                              password.isEmpty ||
                              confirmPassword.isEmpty) {
                            showCustomSnackBar(
                              context,
                              "Please fill in all fields",
                            );
                            return;
                          }

                          if (password != confirmPassword) {
                            showCustomSnackBar(
                              context,
                              "Passwords do not match!",
                            );
                            return;
                          }

                          if (password.length < 6) {
                            showCustomSnackBar(
                              context,
                              "Password must be at least 6 characters",
                            );
                            return;
                          }

                          setState(() => _isLoading = true);
                          var user = await _authService.signUpWithEmail(
                            email,
                            password,
                          );
                          setState(() => _isLoading = false);

                          if (user != null) {
                            showCustomSnackBar(
                              context,
                              "Registration Successful!",
                            );
                            Navigator.pop(context);
                          } else {
                            showCustomSnackBar(
                              context,
                              "Registration Failed! Try again.",
                            );
                          }
                        },
                      ),
                const SizedBox(height: 24),

                /// already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFF00BFA5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
