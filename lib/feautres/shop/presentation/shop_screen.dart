import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({Key? Key}) : super(key: Key);
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  List<dynamic> myBranches = [];
  @override
  void initState() {
    super.initState();
    getInfoAboutMe();
  }

  Future<void> getInfoAboutMe() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    print('this is the user id or something');
    final userString = prefs.getString('user');
    String userRealId = '';
    if (userString != null) {
      userRealId = jsonDecode(userString)['id'];
      print(userRealId);
    } else {
      print('No user data found.');
    }
    print(user);
    try {
      final response = await ApiService.getInfoAboutMe(userRealId);
      response.map((e) => {myBranches.addAll(e['branches'])});
      print('below this is the branches in array or double array');
      print(myBranches);
      print('below is this the response');
      print(response);
    } catch (error) {
      print(error);
    }
  }

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
        onPressed: () async {
          try {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext modalContext) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'Select Branch',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: 6,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                        value: 'value',
                                        groupValue: 'value',
                                        onChanged: (value) {});
                                  }))
                        ],
                      ),
                    );
                  });
                  // return Padding(
                  //   padding: EdgeInsets.only(
                  //       left: 10, right: 10, top: 20, bottom: 40),
                  //   child: Column(
                  //     children: [
                  //       Text('Choose a branch to add a product to'),
                  //       SizedBox(height: 10),
                  //       DropdownButtonFormField(
                  //           value: 'data1',
                  //           items: const [
                  //             DropdownMenuItem(
                  //                 value: 'data1', child: Text('data')),
                  //             DropdownMenuItem(
                  //                 value: 'data2', child: Text('data')),
                  //             DropdownMenuItem(
                  //                 value: 'data3', child: Text('data')),
                  //           ],
                  //           selectedItemBuilder: (context) {
                  //             return const [Text('data')];
                  //           },
                  //           onChanged: (value) {})
                  //     ],
                  //   ),
                  // );
                });
          } catch (error) {}
        },
        label: Text("Add Items To Shop"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
