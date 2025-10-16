import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class AddWorkerScreen extends ConsumerStatefulWidget {
  const AddWorkerScreen({Key? key}) : super(key: key);
  @override
  _AddWorkerScreenState createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends ConsumerState<AddWorkerScreen> {
  List<Map<String, dynamic>> formatedWorkers = [];
  bool isLoadingWorkers = true;
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    fetchUsers(); // like useEffect(() => fetchUsers(), [])
  }

  Future<void> fetchUsers() async {
    try {
      final response = await ApiService.fetchWorker();
      formatedWorkers = response
          .map(
            (e) => {
              'id': e['id'],
              'name': e['name'],
              'address': e['branch']['name'],
              'type': e['branch']['houseType'] == 'SHOP' ? 'Shop' : 'Warehouse',
              'status': 'Active', // dummy status
            },
          )
          .toList();
      if (!response.isEmpty) {
        //  setState(() {
        //       Workers = json.decode(response);
        //       isLoadingWorkers = false;
        //     });
      }
      setState(() {
        isLoadingWorkers = false;
      });
    } catch (error) {
      setState(() {
        isLoadingWorkers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingWorkers) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
        length: 3, // number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: const Text('User Management'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'All Users'),
                Tab(text: 'Warehouse'),
                Tab(text: 'Shop'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildBranchList(
                formatedWorkers,
                (_) {},
                context,
              ),
              _buildBranchList(
                formatedWorkers.where((b) => b['type'] == 'Warehouse').toList(),
                (_) {},
                context,
              ),
              _buildBranchList(
                formatedWorkers.where((b) => b['type'] == 'Shop').toList(),
                (_) {},
                context,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _showAddWorkerModal(context, formatedWorkers, (_) {});
            },

            icon: const Icon(
              Icons.person_add_alt_1, // looks better for “add worker”
              color: Colors.white,
            ),
            label: const Text(
              "Add New Worker",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.blue, // Blue button background
            elevation: 6, // adds nice shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // softer rounded corners
            ),
          ),
        ));
  }

  void _showAddWorkerModal(BuildContext modalContext,
      List<Map<String, dynamic>> branches, StateSetter setModalState) {
    String selectedType = 'SHOP';
    String selectedRole = 'Sales';
    final List<Map<String, dynamic>> roles = [
      {
        'value': 'Sales',
        'label': 'Sales',
        'icon': Icons.sell,
        'description': 'Handles selling products to customers',
        'color': Colors.green,
      },
      {
        'value': 'Shop_Keeper',
        'label': 'Shop Keeper',
        'icon': Icons.store,
        'description': 'Manages store inventory and operations',
        'color': Colors.orange,
      },
      {
        'value': 'Admin',
        'label': 'Admin',
        'icon': Icons.admin_panel_settings,
        'description': 'Oversees system settings and staff management',
        'color': Colors.blue,
      },
    ];
    bool isLoading = false;

    TextEditingController branchNameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                height: MediaQuery.of(innerModalContext).size.height * 0.8,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add New Worker',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: branchNameController,
                        decoration: const InputDecoration(
                          labelText: 'Worker Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefix: Icon(Icons.vpn_key),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setInnerModalState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(Icons.visibility),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        items: roles.map((role) {
                          return DropdownMenuItem<String>(
                            value: role['value'],
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: role['color'],
                                  child: Icon(role['icon'],
                                      size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      role['label'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      role['description'],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setInnerModalState(() {
                            selectedRole = newValue!;
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
                                      final address =
                                          phoneNumberController.text;
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
                                          Fluttertoast.showToast(
                                            msg:
                                                "Branch added successfully: ${result['name']}",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.TOP,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } catch (error) {
                                          // Close the inner modal
                                          Navigator.pop(innerModalContext);

                                          // Show error toast
                                          Fluttertoast.showToast(
                                            msg: "Error: $error",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.TOP,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } finally {
                                          setInnerModalState(
                                              () => isLoading = false);
                                        }
                                      } else {
                                        // Close the inner modal
                                        Navigator.pop(innerModalContext);

                                        // Show validation error toast
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
                                          Fluttertoast.showToast(
                                            msg:
                                                "Branch added successfully: ${result['name']}",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.TOP,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } catch (error) {
                                          // Close the inner modal
                                          Navigator.pop(innerModalContext);

                                          // Show error toast
                                          Fluttertoast.showToast(
                                            msg: "Error: $error",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.TOP,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } finally {
                                          setInnerModalState(
                                              () => isLoading = false);
                                        }
                                      } else {
                                        // Close the inner modal
                                        Navigator.pop(innerModalContext);

                                        // Show validation error toast
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
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
