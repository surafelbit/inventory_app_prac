import 'package:flutter/material.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({Key? key}) : super(key: key);
  @override
  _WarehousePageState createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          width: double.infinity,
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Items',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // optional

              children: [
                Row(
                  children: [Text('filter'), Icon(Icons.filter_alt)],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [Text('sort'), Icon(Icons.sort)],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [Text('collection'), Icon(Icons.collections)],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Add Item To Warehouse"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
