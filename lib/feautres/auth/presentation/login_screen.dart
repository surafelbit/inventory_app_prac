import 'package:flutter/material.dart';
import './../../home/presentation/home_screen.dart';
import 'admin_login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for the text fields
  final TextEditingController orgNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    final orgNumber = orgNumberController.text.trim();
    final password = passwordController.text.trim();

    if (orgNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/workers/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'organizationPhone': orgNumber, // or use an emailController
          'password': password,
        }),
      );
      print('the inputs man: ${orgNumber}');
      print('Raw response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
        if (data['success'] == true) {
          // ✅ Credentials correct: go to HomeScreen
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => HomeScreen()),
          // );
        } else {
          // ❌ Invalid credentials
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid credentials")),
          );
        }
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('raw response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: ${response.statusCode}")),
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
    // Always dispose controllers
    orgNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.business, size: 64, color: Colors.blueAccent),
                      SizedBox(height: 16),
                      Text(
                        "Organization Login",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24),

                      // Organization Number
                      TextField(
                        controller: orgNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Organization Number',
                          prefixIcon: Icon(Icons.confirmation_number),
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

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: handleLogin,
                          child: Text("Login", style: TextStyle(fontSize: 18)),
                        ),
                      ),

                      // Forgot Password (optional)
                      TextButton(
                        onPressed: () {
                          // Add forgot password logic here
                        },
                        child: Text("Forgot password?",
                            style: TextStyle(color: Colors.grey[700])),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AdminLoginScreen()),
                          );
                        },
                        child: Text("Login as an admin",
                            style: TextStyle(color: Colors.grey[700])),
                      )
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
