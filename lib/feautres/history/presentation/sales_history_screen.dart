import 'package:flutter/material.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({Key? Key}) : super(key: Key);
  @override
  _SalesHistoryScreenState createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("this is the history of sales"),
      ),
      body: const Center(
        child: Text("this is the page i guess but why the const tho 😒"),
      ),
    );
  }
}
