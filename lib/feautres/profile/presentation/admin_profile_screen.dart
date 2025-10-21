import 'package:flutter/material.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../state/auth/auth_provider.dart';
import 'package:flutter_app/feautres/workers/presentation/add_worker_screen.dart';

class AdminProfileScreen extends ConsumerStatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends ConsumerState<AdminProfileScreen> {
  // Function to handle fetching branches and showing the modal
  void _handleFetchBranches(BuildContext context) async {
    // Show loading dialog
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext dialogContext) {
    //     return Center(
    //       child: CircularProgressIndicator(
    //         color: Colors.blue[600],
    //       ),
    //     );
    //   },
    // );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) {
        return DefaultTabController(
          length: 3,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(modalContext).viewInsets.bottom + 10,
                  left: 20,
                  right: 20,
                  top: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Manage Branches',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TabBar(
                      labelColor: Colors.blue[600],
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue[600],
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Shop'),
                        Tab(text: 'Warehouse'),
                      ],
                    ),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: TabBarView(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    try {
      final response = await ApiService.fetchBranch();
      print('this is the response sun $response');

      // Close loading dialog
      Navigator.of(context).pop();

      // Check if response is empty
      if (response.isEmpty) {
        // Fluttertoast.showToast(
        //   msg: "No branches found",
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.TOP,
        //   backgroundColor: Colors.orange,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No branches found'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ));
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext modalContext) {
            return DefaultTabController(
              length: 3,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(modalContext).viewInsets.bottom + 10,
                      left: 20,
                      right: 20,
                      top: 15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Manage Branches',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TabBar(
                          labelColor: Colors.blue[600],
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.blue[600],
                          tabs: const [
                            Tab(text: 'All'),
                            Tab(text: 'Shop'),
                            Tab(text: 'Warehouse'),
                          ],
                        ),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: TabBarView(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.inbox,
                                        size: 50, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text(
                                      'No branches available',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
        return;
      }

      // Format branches
      List<Map<String, dynamic>> formattedBranches = response.map((branch) {
        return {
          'id': branch['id'],
          'name': branch['name'],
          'type': branch['houseType'] == 'SHOP' ? 'Shop' : 'Warehouse',
          'address': branch['address'] ?? '',
          'status': 'Active', // dummy status
        };
      }).toList();

      // Show the branches modal
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext modalContext) {
          return DefaultTabController(
            length: 3,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(modalContext).viewInsets.bottom + 10,
                    left: 20,
                    right: 20,
                    top: 15,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Manage Branches',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TabBar(
                        labelColor: Colors.blue[600],
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue[600],
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Shop'),
                          Tab(text: 'Warehouse'),
                        ],
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: TabBarView(
                          children: [
                            // All Tab
                            _buildBranchList(
                              formattedBranches,
                              setModalState,
                              modalContext,
                            ),
                            // Shop Tab
                            _buildBranchList(
                              formattedBranches
                                  .where((b) => b['type'] == 'Shop')
                                  .toList(),
                              setModalState,
                              modalContext,
                            ),
                            // Warehouse Tab
                            _buildBranchList(
                              formattedBranches
                                  .where((b) => b['type'] == 'Warehouse')
                                  .toList(),
                              setModalState,
                              modalContext,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildBox('Add New Branch', Icons.add_business, () {
                        _showAddBranchModal(
                            modalContext, formattedBranches, setModalState);
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    } catch (error) {
      // Close loading dialog
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ));
      // Show error toast
      // Fluttertoast.showToast(
      //   msg: "Failed to fetch branches: $error",
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.TOP,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext modalContext) {
          return DefaultTabController(
            length: 3,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(modalContext).viewInsets.bottom + 10,
                    left: 20,
                    right: 20,
                    top: 15,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Manage Branches',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TabBar(
                        labelColor: Colors.blue[600],
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue[600],
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Shop'),
                          Tab(text: 'Warehouse'),
                        ],
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: TabBarView(
                          children: [
                            Center(
                              child: Text(
                                'Network error. Please try again.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=3'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'abebe@example.com',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.military_tech, color: Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(height: 10),
                            Text("Edit Company Profile"),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(height: 10),
                            Text("General Settings"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildProfileOption(Icons.person, 'My Customers', () {}),
                  _buildProfileOption(Icons.credit_card, 'Expenses', () {}),
                  _buildProfileOption(Icons.collections, 'My Collections', () {
                    _handleFetchBranches(context);
                  }),
                  _buildProfileOption(Icons.credit_card, 'My Credits', () {}),
                  _buildProfileOption(Icons.person_2, 'Manage Users', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => (AddWorkerScreen()),
                      ),
                    );
                  }),
                  _buildProfileOption(Icons.build, 'Bulk Import', () {}),
                ],
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

  Widget _buildBranchList(List<Map<String, dynamic>> branches,
      StateSetter setModalState, BuildContext modalContext) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: branches.length,
      itemBuilder: (context, index) {
        final branch = branches[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Icon(
              branch['type'] == 'Shop' ? Icons.store : Icons.warehouse,
              color: branch['type'] == 'Shop' ? Colors.blue : Colors.orange,
            ),
            title: Text(
              branch['name'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(branch['address']),
                Text(
                  '${branch['type']} • ${branch['status']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditBranchDialog(modalContext, branch, (updatedBranch) {
                  setModalState(() {
                    branches[index] = updatedBranch;
                  });
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddBranchModal(BuildContext modalContext,
      List<Map<String, dynamic>> branches, StateSetter setModalState) {
    String selectedType = 'SHOP';
    bool isLoading = false;

    TextEditingController branchNameController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    showModalBottomSheet(
      context: modalContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext innerModalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setInnerModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(innerModalContext).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Container(
                height: MediaQuery.of(innerModalContext).size.height * 0.6,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add New Branch',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: branchNameController,
                        decoration: const InputDecoration(
                          labelText: 'Branch Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Branch Type',
                          border: OutlineInputBorder(),
                        ),
                        items: ['SHOP', 'WAREHOUSE'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setInnerModalState(() {
                            selectedType = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(innerModalContext),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      final name = branchNameController.text;
                                      final address = addressController.text;
                                      if (name.isNotEmpty) {
                                        setInnerModalState(
                                            () => isLoading = true);

                                        try {
                                          final result =
                                              await ApiService.addBranch(
                                                  name, address, selectedType);

                                          // Update the parent modal list
                                          setModalState(() {
                                            branches.add({
                                              'id': branches.length + 1,
                                              'name': result['name'],
                                              'type': result['houseType'] ??
                                                  selectedType,
                                              'address': result['address'] ??
                                                  'No address',
                                              'status': 'Active',
                                            });
                                          });

                                          // Close the inner modal
                                          Navigator.pop(innerModalContext);

                                          // Show success toast
                                          // Fluttertoast.showToast(
                                          //   msg:
                                          //       "Branch added successfully: ${result['name']}",
                                          //   toastLength: Toast.LENGTH_LONG,
                                          //   gravity: ToastGravity.TOP,
                                          //   backgroundColor: Colors.green,
                                          //   textColor: Colors.white,
                                          //   fontSize: 16.0,
                                          // );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "User added successfully: ${result['name']}"),
                                              backgroundColor: Colors.green,
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        } catch (error) {
                                          // Close the inner modal
                                          Navigator.pop(innerModalContext);

                                          // Show error toast
                                          // Fluttertoast.showToast(
                                          //   msg: "Error: $error",
                                          //   toastLength: Toast.LENGTH_LONG,
                                          //   gravity: ToastGravity.TOP,
                                          //   backgroundColor: Colors.red,
                                          //   textColor: Colors.white,
                                          //   fontSize: 16.0,
                                          // );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Error $error'),
                                            backgroundColor: Colors.red,
                                            duration:
                                                const Duration(seconds: 4),
                                          ));
                                        } finally {
                                          setInnerModalState(
                                              () => isLoading = false);
                                        }
                                      } else {
                                        // Close the inner modal
                                        Navigator.pop(innerModalContext);

                                        // Show validation error toastc
                                        Fluttertoast.showToast(
                                          msg: "Please enter a branch name",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.TOP,
                                          backgroundColor: Colors.orange,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                    },
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('Add Branch'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditBranchDialog(BuildContext context, Map<String, dynamic> branch,
      Function(Map<String, dynamic>) onUpdate) {
    TextEditingController nameController =
        TextEditingController(text: branch['name']);
    TextEditingController addressController =
        TextEditingController(text: branch['address']);
    String selectedType = branch['type'];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Branch'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Branch Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Branch Type',
                        border: OutlineInputBorder(),
                      ),
                      items: ['SHOP', 'WAREHOUSE'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedType = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final updatedBranch = {
                      'id': branch['id'],
                      'name': nameController.text,
                      'type': selectedType,
                      'address': addressController.text.isNotEmpty
                          ? addressController.text
                          : 'No address',
                      'status': branch['status'],
                    };
                    onUpdate(updatedBranch);
                    Navigator.pop(dialogContext);
                    Fluttertoast.showToast(
                      msg: "Branch updated successfully!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
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
      onTap: onTap,
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
}
