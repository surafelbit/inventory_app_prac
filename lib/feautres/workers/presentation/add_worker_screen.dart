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
  List<String> selectedPermissions = [];
  List<String> selectedBranchs = [];
  bool isLoadingWorkers = true;
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchBranch();
    // like useEffect(() => fetchUsers(), [])
  }

  List<Map<String, dynamic>> formattedBranches = [];
  Future<void> fetchUsers() async {
    try {
      final response = await ApiService.fetchWorker();
      formatedWorkers = response
          .map(
            (e) => {
              'id': e['id'],
              'name': e['name'],
              'userType': e['userType'],
              'address': e['branches'].map((e) => e['name']).toList(),
              // 'type': e['branches'].isNotEmpty
              //     ? e['branches']
              //         .map((b) =>
              //             b['houseType'] == 'SHOP' ? 'Shop' : 'Warehouse')
              //         .toList()
              //     : ['N/A'],

              'type': e['branches'].isNotEmpty
                  ? (e['branches'][0]['houseType'] == 'SHOP'
                      ? 'Shop'
                      : 'Warehouse')
                  : 'N/A',
              'status': 'Active', // dummy status
            },
          )
          .toList();

      setState(() {
        isLoadingWorkers = false;
      });
    } catch (error) {
      setState(() {
        isLoadingWorkers = false;
      });
    }
  }

  Future<void> fetchBranch() async {
    try {
      final response = await ApiService.fetchBranch();
      formattedBranches = response.map((branch) {
        return {
          'id': branch['id'] ?? '',
          'name': branch['name'] ?? '',
          'type': branch['houseType'] == 'SHOP' ? 'Shop' : 'Warehouse',
          'address': branch['address'] ?? '',
          'status': 'Active', // dummy status
        };
      }).toList();
    } catch (error) {
      print(error);
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
    String selectedRole = 'SALES';
    String selectedBranch = 'cmesoe9x40001l9c4ai9z0xbl';
    final List<Map<String, dynamic>> roles = [
      {
        'value': 'SALES',
        'label': 'Sales',
        'icon': Icons.sell,
        'description': 'Handles selling products to customers',
        'color': Colors.green,
      },
      {
        'value': 'SHOP_KEEPER',
        'label': 'Shop Keeper',
        'icon': Icons.store,
        'description': 'Manages store inventory and operations',
        'color': Colors.orange,
      },
      {
        'value': 'Admin',
        'label': 'SHOP_OWNER',
        'icon': Icons.admin_panel_settings,
        'description':
            'Oversees system settings and staff management acts as the owner',
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
                          labelText: 'Phone Number',
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
                            icon: _obscureText
                                ? Icon(Icons.visibility)
                                : Icon(Icons.vpn_key),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        isExpanded: true, // allows full width
                        // 👇 What is displayed when dropdown is closed
                        selectedItemBuilder: (context) {
                          return roles.map((role) {
                            return Text(
                              role['label'], // only show title like "Sales"
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            );
                          }).toList();
                        },
                        // 👇 What is displayed when dropdown is open
                        items: roles.map((role) {
                          return DropdownMenuItem<String>(
                            value: role['value'],
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: role['color'],
                                  child: Icon(role['icon'],
                                      size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        role['label'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        role['description'],
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
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
                      const SizedBox(height: 15),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: modalContext,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                            List<Map<String, dynamic>> availableBranches = [];

                            try {
                              final response = await ApiService.fetchBranch();
                              availableBranches = response.map((e) {
                                return {
                                  'id': e['id'],
                                  'name': e['name'],
                                  'houseType': e['houseType']
                                };
                              }).toList();
                              Navigator.of(modalContext).pop();
                              showModalBottomSheet(
                                  context: modalContext,
                                  builder: (BuildContext innerModalContext) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Select Permissions',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 16),
                                              Expanded(
                                                  child: ListView.builder(
                                                      itemCount:
                                                          availableBranches
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final perm =
                                                            availableBranches[
                                                                index];
                                                        final isSelected =
                                                            selectedBranchs
                                                                .contains(
                                                                    perm['id']);
                                                        return CheckboxListTile(
                                                          value: isSelected,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              if (value ==
                                                                  false) {
                                                                selectedBranchs
                                                                    .remove(perm[
                                                                        'id']);
                                                              } else {
                                                                selectedBranchs
                                                                    .add(perm[
                                                                        'id']);
                                                                print(
                                                                    selectedBranchs);
                                                              }
                                                            });
                                                          },
                                                          title: Text(
                                                              perm['name']),
                                                        );
                                                      })),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Here you can call your API to send them
                                                  Navigator.of(
                                                          innerModalContext)
                                                      .pop(); // close modal
                                                },
                                                child: Text(
                                                    'Add Branches And Go Back'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  });
                            } catch (error) {
                              showDialog(
                                context: modalContext,
                                builder: (context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(
                                      'Failed to fetch permissions: $error'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 202, 171, 207),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 8.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Select Branches',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Show circular loading modal immediately
                            showDialog(
                              context: modalContext,
                              barrierDismissible:
                                  false, // user cannot close while loading
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            List<Map<String, dynamic>> allowedPermissions = [];

                            try {
                              // Fetch permissions
                              final response =
                                  await ApiService.fetchPermissions();
                              print(response);
                              allowedPermissions = response
                                  .map((perm) => {
                                        'id': perm['id'],
                                        'name': perm['name'],
                                        'description': perm['description'],
                                        'category': perm['category'],
                                        'createdAt': perm['createdAt'],
                                        'updatedAt': perm['updatedAt'],
                                      })
                                  .toList();

                              // Close the loading dialog
                              Navigator.of(modalContext).pop();

                              // Show the modal with fetched permissions
                              showModalBottomSheet(
                                context: modalContext,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                builder: (BuildContext innerModalContext) {
                                  // keep track of selection

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      // <-- setState for bottom sheet
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        height: MediaQuery.of(innerModalContext)
                                                .size
                                                .height *
                                            0.7,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Select Permissions',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 16),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount:
                                                    allowedPermissions.length,
                                                itemBuilder: (context, index) {
                                                  final perm =
                                                      allowedPermissions[index];
                                                  final isSelected =
                                                      selectedPermissions
                                                          .contains(perm['id']);

                                                  return CheckboxListTile(
                                                    value: isSelected,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        // <-- IMPORTANT
                                                        if (value == true) {
                                                          selectedPermissions
                                                              .add(perm['id']);
                                                        } else {
                                                          selectedPermissions
                                                              .remove(
                                                                  perm['id']);
                                                        }
                                                      });
                                                    },
                                                    title: Text(perm['name']),
                                                    subtitle: Text(
                                                        perm['description']),
                                                  );
                                                },
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                print(
                                                    'Selected Permissions: $selectedPermissions');
                                                // Here you can call your API to send them
                                                Navigator.of(innerModalContext)
                                                    .pop(); // close modal
                                              },
                                              child: Text(
                                                  'Add Permissions And Go Back'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } catch (error) {
                              // Close the loading dialog in case of error                             Navigator.of(modalContext).pop();
                              print(error);
                              // Show error message
                              showDialog(
                                context: modalContext,
                                builder: (context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(
                                      'Failed to fetch permissions: $error'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 202, 171, 207),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Allow Permissions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              onPressed: () async {
                                final name = branchNameController.text;
                                final phone = phoneNumberController.text;
                                if (name.isNotEmpty) {
                                  setInnerModalState(() => isLoading = true);

                                  try {
                                    final result =
                                        // await ApiService.addBranch(
                                        //     name, phone, selectedType);
                                        await ApiService.addWorkers(
                                      name,
                                      phone,
                                      passwordController.text,
                                      selectedRole,
                                      selectedBranchs,
                                      // ['cmesoe9x40001l9c4ai9z0xbl'],
                                      selectedPermissions,
                                    );
                                    // Update the parent modal list
                                    setModalState(() {
                                      branches.add({
                                        'id': branches.length + 1,
                                        'name': result['name'],
                                        'type':
                                            result['houseType'] ?? selectedType,
                                        'address':
                                            result['address'] ?? 'No address',
                                        'status': 'Active',
                                      });
                                    });

                                    // Close the inner modal
                                    Navigator.pop(innerModalContext);

                                    // Show success toast
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "User added successfully: ${result['name']}"),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  } catch (error) {
                                    // Close the inner modal
                                    Navigator.pop(innerModalContext);
                                    print(
                                        '$error this is the error that is regarding to adding users');
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
                                      content: Text(
                                          'Error Couldnt Add The Worker $error'),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 4),
                                    ));
                                  } finally {
                                    setInnerModalState(() => isLoading = false);
                                  }
                                } else {
                                  // Close the inner modal

                                  // Show validation error toast
                                  Fluttertoast.showToast(
                                    msg: "Please enter a branch name",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('Add Worker'),
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
                                          print(error);
                                          // Show error toast
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

                                        // Show validation error toast
                                        Fluttertoast.showToast(
                                          msg: "Please enter a branch name",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.TOP,
                                          backgroundColor: Colors.red,
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
                ...branch['address'].map((e) => Text(e)),
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
