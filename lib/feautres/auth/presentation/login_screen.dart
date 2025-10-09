import 'package:flutter/material.dart';
import './../../home/presentation/home_screen.dart';
import '../../home/presentation/welcome_screen.dart';
import 'admin_login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/auth/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Controllers for the text fields
  final TextEditingController orgNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    orgNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        // Background gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.business,
                          size: 64, color: Colors.blueAccent),
                      const SizedBox(height: 16),
                      const Text(
                        "Organization Login",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Organization Number
                      TextField(
                        controller: orgNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Organization Number',
                          prefixIcon: Icon(Icons.confirmation_number),
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                              //  borderRadius:  BorderRadius.circular(12),
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      authState.isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  await ref.read(authProvider.notifier).login(
                                        orgNumberController.text,
                                        passwordController.text,
                                      );

                                  final state = ref.read(authProvider);
                                  if (state.isLoggedIn) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const WelcomeScreen(),
                                      ),
                                    );
                                  } else if (state.error != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.error!)),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                      // Forgot Password (optional)
                      TextButton(
                        onPressed: () {
                          // Add forgot password logic here
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminLoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Login as an admin",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
