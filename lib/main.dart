import 'package:flutter/material.dart';
import 'feautres/auth/presentation/login_screen.dart';
import 'feautres/home/presentation/welcome_screen.dart';
import './state/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feautres/profile/presentation/admin_profile_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(), // start with login screen
      // home: const WelcomeScreen(),
      home: AdminProfileScreen(),
    );
  }
}
