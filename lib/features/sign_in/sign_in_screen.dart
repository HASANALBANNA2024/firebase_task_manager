import 'package:firebase_task_manager/core/widgets/app_button.dart';
import 'package:firebase_task_manager/core/widgets/app_logo.dart';
import 'package:firebase_task_manager/core/widgets/app_message.dart';
import 'package:firebase_task_manager/core/widgets/app_text_field.dart';
import 'package:firebase_task_manager/features/sign_up/sign_up_screen.dart';
import 'package:firebase_task_manager/main_navigation_screen.dart';
// Import your auth provider file here
// import 'package:firebase_task_manager/core/riverpod_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/riverpod_provider/auth_provider.dart';
import '../../firebase/authentication/auth_service.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch loading state and read auth notifier from Riverpod
    final isLoading = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

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
              /// Back button
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

              /// Email input field
              AppTextField(
                controller: _emailController,
                labelText: "Email",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              /// Password input field
              AppTextField(
                controller: _passwordController,
                labelText: "Password",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 12),

              /// Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showResetPasswordDialog(context, ref),
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

              /// Login button with Riverpod loading state handler
              isLoading
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

                        // Call sign in with email from auth notifier
                        var user = await authNotifier.signInWithEmail(
                          email,
                          password,
                        );

                        if (user != null) {
                          if (context.mounted) {
                            showCustomSnackBar(context, "Login Successful!");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainNavigationScreen(),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            showCustomSnackBar(
                              context,
                              "Login Failed! Check your credentials.",
                            );
                          }
                        }
                      },
                    ),
              const SizedBox(height: 24),

              /// Navigate to sign up screen
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
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
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

  /// Password reset dialogue method
  void _showResetPasswordDialog(BuildContext context, WidgetRef ref) {
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
                  // Accessing auth service via riverpod provider inside dialog
                  final authService = ref.read(authServiceProvider);
                  bool success = await authService.resetPassword(email);

                  if (context.mounted) {
                    Navigator.pop(context);
                    showCustomSnackBar(
                      context,
                      success
                          ? "Password reset link sent to your email"
                          : "Failed to send reset link. Check your email.",
                    );
                  }
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
