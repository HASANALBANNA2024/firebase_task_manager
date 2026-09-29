import 'package:firebase_task_manager/core/widgets/app_button.dart';
import 'package:firebase_task_manager/core/widgets/app_logo.dart';
import 'package:firebase_task_manager/core/widgets/app_message.dart';
import 'package:firebase_task_manager/features/sign_in/sign_in_screen.dart';
import 'package:firebase_task_manager/firebase/authentication/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// logo icon
                      const AppLogo(),
                      const SizedBox(height: 24),
                      const Text(
                        "Plan it. \nSync it. \nDone",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// subtitle title text
                      Text(
                        "Tasks save to the cloud and remind you on every device.",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 48),

                      AppButton(
                        text: "Continue with Google",
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        icon: const Icon(Icons.person_outline),
                        onPressed: () async {
                          var user = await authService.signInWithGoogle();
                          if (user != null) {
                            showCustomSnackBar(
                              context,
                              "Google sign-in Successfull: ${user.displayName}",
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      AppButton(
                        text: "Sign in with email",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          "By continuing you accept the Terms and Privacy Policy",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
