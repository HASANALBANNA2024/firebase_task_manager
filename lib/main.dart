import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_task_manager/core/riverpod_provider/auth_provider.dart';
import 'package:firebase_task_manager/features/login/login_screen.dart';
import 'package:firebase_task_manager/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Firebase Task Manager",
      home: authState.when(
        data: (user) {
          if (user != null) {
            return MainNavigationScreen();
          }
          return LoginScreen();
        },
        error: (error, stackTrace) =>
            Scaffold(body: Center(child: Text("Error $error"))),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF0E9F8E)),
          ),
        ),
      ),
    );
  }
}
