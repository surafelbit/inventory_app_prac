import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        onPressed: () {
          // handle button press here
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
}
