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
        title: Text('Warehouse Page'),
      ),
    );
  }
}
