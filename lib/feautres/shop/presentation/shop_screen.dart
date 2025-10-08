import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? Key}) : super(key: Key);
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
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
                  hintText: 'Search Items In Shop',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5))),
            )),
      ),
      body: (SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Add Items To Shop"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
