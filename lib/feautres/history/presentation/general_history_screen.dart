import 'package:flutter/material.dart';

class GeneralHistoryScreen extends StatefulWidget {
  const GeneralHistoryScreen({Key? Key}) : super(key: Key);
  _GeneralHistoryScreenState createState() => _GeneralHistoryScreenState();
}

class _GeneralHistoryScreenState extends State<GeneralHistoryScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("General history"),
        ),
        body: const Center(
          child:
              Text("This is the text inside the body of the general history"),
        ));
  }
}
