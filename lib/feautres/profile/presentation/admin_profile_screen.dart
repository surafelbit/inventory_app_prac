import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/auth/auth_provider.dart';

class AdminProfileScreen extends ConsumerStatefulWidget {
  const AdminProfileScreen({Key? Key}) : super(key: Key);
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends ConsumerState<AdminProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authProvider);
    final authState = ref.read(authProvider);
    print('this is the user ');
    print(authState.user?.name);
    print('this is the user ');
    final userName = authState.user?.name ?? 'Admin Bra'; // fallback if null
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
                                const Text(
                                  'abebe@example.com',
                                  style: TextStyle(color: Colors.white70),
                                ),
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
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // 🔥 allows full height if needed
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 10,
                              left: 20,
                              right: 20,
                              top: 15,
                            ),
                            child: SingleChildScrollView(
                              // ✅ makes it scrollable if tall
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Add New Branch',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),

                                  // ✅ Grid-style layout
                                  Wrap(
                                    spacing:
                                        20, // horizontal space between boxes
                                    runSpacing:
                                        15, // vertical space between rows
                                    alignment: WrapAlignment.center,
                                    children: [
                                      _buildBox(
                                          'Add Branch', Icons.account_tree, () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                          builder: (context) {
                                            String selected =
                                                'all'; // local state

                                            return StatefulBuilder(
                                              builder:
                                                  (context, setModalState) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom,
                                                    left: 20,
                                                    right: 20,
                                                    top: 20,
                                                  ),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                    width: double.infinity,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Text(
                                                            'Select Branch Type',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 20),

                                                          // ✅ Selectable buttons
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              'all',
                                                              'warehouse',
                                                              'shop'
                                                            ].map((item) {
                                                              final bool
                                                                  isSelected =
                                                                  selected ==
                                                                      item;

                                                              return GestureDetector(
                                                                onTap: () {
                                                                  // 👇 FIXED: use setModalState instead of setState
                                                                  setModalState(
                                                                      () {
                                                                    selected =
                                                                        item;
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: isSelected
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .grey[300],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Text(
                                                                    item,
                                                                    style:
                                                                        TextStyle(
                                                                      color: isSelected
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                          Row(
                                                            children: [
                                                              const TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Add Branch Name',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          ElevatedButton(
                                                              onPressed: () {},
                                                              // decoration:BoxDecoration(color:Colors.purple),kk
                                                              child: Text(
                                                                  'Add New Branch ${selected}')),
                                                          const SizedBox(
                                                              height: 30),
                                                          Text(
                                                              'Selected: $selected'),
                                                          const SizedBox(
                                                              height: 20),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }),
                                      _buildBox(
                                          'Add Supplier', Icons.people, () {}),
                                      _buildBox(
                                          'Add Group', Icons.group_work, () {}),
                                      _buildBox('Add Mark', Icons.check_circle,
                                          () {}),
                                      _buildBox('Add Measur', Icons.straighten,
                                          () {}),
                                      _buildBox('Add Brand', Icons.shopping_bag,
                                          () {}),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      );

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

  Widget _buildBox(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, // 👈 handles the tap
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: Colors.black54),
            SizedBox(height: 6),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableButton(
      String label, String selected, void Function(void Function()) setState) {
    final bool isSelected = selected == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selected = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
