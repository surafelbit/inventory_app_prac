import 'package:flutter/material.dart';
import 'package:flutter_app/state/auth/auth_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './../../home/presentation/home_screen.dart';
import './../../home/presentation/welcome_screen.dart';
import '../../../state/auth/auth_provider.dart';
import 'login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleAdminLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      await ref.read(authProvider.notifier).loginAdmin(email, password);
      final state = await ref.read(authProvider);
      if (state.isLoggedIn) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
      } else if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)),
        );
      }
      // final response = await http.post(
      //   Uri.parse('http://localhost:3000/auth/login'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'email': email, // or use an emailController
      //     'password': password,
      //   }),
      // );

      if (state.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: error")),
        );
      }
    } catch (e) {
      print('Request failed: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.admin_panel_settings,
                      size: 64, color: Colors.blueAccent),
                  SizedBox(height: 16),
                  Text(
                    "Admin Login",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),

                  // Email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  authState.isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: handleAdminLogin,
                            child: Text("Login as Admin",
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                  SizedBox(height: 24),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Text("Login as an worker",
                        style: TextStyle(color: Colors.grey[700])),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
