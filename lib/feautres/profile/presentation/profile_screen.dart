import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Profile Header ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.blue[600],
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=3'), // placeholder image
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Abebe Yene',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'abebe@example.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Profile Options ---
            _buildProfileOption(Icons.edit, 'Edit Profile', () {
              // Navigate to edit profile page
            }),
            _buildProfileOption(Icons.settings, 'Settings', () {
              // Navigate to settings page
            }),
            _buildProfileOption(Icons.history, 'Activity', () {
              // Navigate to activity page
            }),
            _buildProfileOption(Icons.logout, 'Logout', () {
              // Handle logout
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[600]),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
