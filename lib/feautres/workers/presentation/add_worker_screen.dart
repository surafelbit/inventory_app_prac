import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddWorkerScreen extends ConsumerStatefulWidget {
  const AddWorkerScreen({Key? key}) : super(key: key);
  @override
  _AddWorkerScreenState createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends ConsumerState<AddWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Managment'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final response = await ApiService.fetchWorker();
            List<Map<String, dynamic>> formatedUsers = response
                .map(
                  (e) => {
                    'id': e['id'],
                    'name': e['name'],
                    'address': e['branch']['name'],
                    'type': e['branch']['houseType'] == 'SHOP'
                        ? 'Shop'
                        : 'Warehouse',
                    'status': 'Active', // dummy status
                  },
                )
                .toList();
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
                              MediaQuery.of(modalContext).viewInsets.bottom +
                                  10,
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
                                    formatedUsers,
                                    setModalState,
                                    modalContext,
                                  ),
                                  // Shop Tab
                                  _buildBranchList(
                                    formatedUsers
                                        .where((b) => b['type'] == 'Shop')
                                        .toList(),
                                    setModalState,
                                    modalContext,
                                  ),
                                  // Warehouse Tab
                                  _buildBranchList(
                                    formatedUsers
                                        .where((b) => b['type'] == 'Warehouse')
                                        .toList(),
                                    setModalState,
                                    modalContext,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildBox('Add New Worker', Icons.person_add_alt,
                                () {
                              _showAddBranchModal(
                                  modalContext, formatedUsers, setModalState);
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
            print(
                'error this is the error on the new addition of workers $error');
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
                              MediaQuery.of(modalContext).viewInsets.bottom +
                                  10,
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
