import 'package:firebase_task_manager/core/widgets/app_button.dart';
import 'package:firebase_task_manager/core/widgets/app_logo.dart';
import 'package:firebase_task_manager/core/widgets/app_message.dart';
import 'package:firebase_task_manager/core/widgets/app_text_field.dart';
import 'package:firebase_task_manager/features/sign_up/sign_up_screen.dart';
import 'package:firebase_task_manager/firebase/authentication/auth_service.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 20),
              const AppLogo(size: 60, iconSize: 32),
              const SizedBox(height: 24),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Log in to continue managing your tasks.",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),
              AppTextField(
                controller: _emailController,
                labelText: "Email",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                labelText: "Password",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 12),

              /// forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showResetPasswordDialog(context),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xFF00BFA5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// login button reusable widget
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00BFA5),
                      ),
                    )
                  : AppButton(
                      text: "Login",
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        if (email.isEmpty || password.isEmpty) {
                          showCustomSnackBar(
                            context,
                            "Please fill in all fields",
                          );
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        var user = await _authService.signInWithEmail(
                          email,
                          password,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        if (user != null) {
                          showCustomSnackBar(context, "Login Successful!");
                        } else {
                          showCustomSnackBar(
                            context,
                            "Login Failed! Check your credentials.",
                          );
                        }
                      },
                    ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
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
    );
  }

  /// password reset dialogue
  void _showResetPasswordDialog(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B132B),
          title: const Text(
            "Reset Password",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: resetEmailController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Enter your email",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  bool success = await _authService.resetPassword(email);
                  Navigator.pop(context);
                  showCustomSnackBar(
                    context,
                    success
                        ? "Password reset link sent to your email"
                        : "Failed to send reset link. check email.",
                  );
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }
}
