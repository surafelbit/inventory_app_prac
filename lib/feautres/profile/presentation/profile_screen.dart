import 'package:flutter/material.dart';
import 'package:flutter_app/state/auth/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/auth/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authProvider);
    final authState = ref.read(authProvider);
    final something = [];
    bool workerUserType;
    print('this is the user ');
    print(authState.user);
    print(authState.user);
    print('this below is the length of the branches');
    print(authState.branches.length);
    print(authState.branches?.map((e) => e.houseType).toList());
    something.addAll(authState?.branches?.map((e) => e.houseType) ?? []);

    print(something);
    print(something.contains('SHOP'));
    workerUserType = something.contains('SHOP');
    print('this is the user ');
    final userName = authState.user?.name ?? 'Guest'; // fallback if null
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: Icon(Icons.person),
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
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/150?img=3'), // placeholder image
                          ),
                          const SizedBox(width: 10),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.military_tech,
                                  color: Colors.purple,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 200),
              child: Container(
                width: 1000,
                // height: 100,
                // color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      // color: Colors.white,
                      padding: EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Edit Company Profile"),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Icon(Icons.settings),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("General Settings"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    _buildProfileOption(Icons.person, 'My Customers', () {}),
                    _buildProfileOption(Icons.credit_card, 'Expenses', () {
                      // Navigate to edit profile page
                    }),
                    _buildProfileOption(Icons.collections, 'My Collections',
                        () {
                      // Navigate to settings page
                    }),
                    _buildProfileOption(Icons.credit_card, 'My Credits', () {
                      // Navigate to activity page
                    }),
                    _buildProfileOption(Icons.person_2, 'Manage Users', () {
                      // Handle logout
                    }),
                    _buildProfileOption(Icons.build, 'Bulk Import', () {})
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.logout),
        label: Text("Logout"),
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
