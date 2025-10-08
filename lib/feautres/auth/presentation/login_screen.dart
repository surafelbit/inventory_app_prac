// import 'package:flutter/material.dart';
// import './../../home/presentation/home_screen.dart';
// import 'admin_login_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../state/auth/auth_provider.dart';
// import '../../../state/auth/auth_state.dart';
// import './../../home/presentation/welcome_screen.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   // Controllers for the text fields
//   final TextEditingController orgNumberController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();

//     // Listen for changes in auth state
//     ref.listen<AuthState>(authProvider, (previous, next) {
//       if (next.isLoggedIn) {
//         // Navigate automatically to WelcomeScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const WelcomeScreen()),
//         );
//       }

//       if (next.error != null && next.error!.isNotEmpty) {
//         // Show error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(next.error!)),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     orgNumberController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   void handleLogin() {
//     final orgNumber = orgNumberController.text.trim();
//     final password = passwordController.text.trim();

//     if (orgNumber.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields")),
//       );
//       return;
//     }

//     // Call the notifier's login method
//     ref.read(authProvider.notifier).login(orgNumber, password);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);

//     return Scaffold(
//       body: Container(
//         // Background gradient
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blueAccent, Colors.lightBlueAccent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(24.0),
//               child: Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(24.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.business, size: 64, color: Colors.blueAccent),
//                       SizedBox(height: 16),
//                       Text(
//                         "Organization Login",
//                         style: TextStyle(
//                             fontSize: 26, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 24),

//                       // Organization Number
//                       TextField(
//                         controller: orgNumberController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           labelText: 'Organization Number',
//                           prefixIcon: Icon(Icons.confirmation_number),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       // Password
//                       TextField(
//                         controller: passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: Icon(Icons.lock),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 24),

//                       // Login Button

//                       authState.isLoading
//                           ? const CircularProgressIndicator()
//                           : SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blueAccent,
//                                   padding: EdgeInsets.symmetric(vertical: 14),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 onPressed: handleLogin,
//                                 child: Text("Login",
//                                     style: TextStyle(fontSize: 18)),
//                               ),
//                             ),
//                       // Forgot Password (optional)
//                       TextButton(
//                         onPressed: () {
//                           // Add forgot password logic here
//                         },
//                         child: Text("Forgot password?",
//                             style: TextStyle(color: Colors.grey[700])),
//                       ),

//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => AdminLoginScreen()),
//                           );
//                         },
//                         child: Text("Login as an admin",
//                             style: TextStyle(color: Colors.grey[700])),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import './../../home/presentation/home_screen.dart';
import 'admin_login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/auth/auth_provider.dart';
import '../../../state/auth/auth_state.dart';
import './../../home/presentation/welcome_screen.dart';

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

  void handleLogin() {
    final orgNumber = orgNumberController.text.trim();
    final password = passwordController.text.trim();

    if (orgNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // Call the notifier's login method
    ref.read(authProvider.notifier).login(orgNumber, password);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen for changes in auth state
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isLoggedIn) {
        // Navigate automatically to WelcomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }

      if (next.error != null && next.error!.isNotEmpty) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

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
                                onPressed: handleLogin,
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
