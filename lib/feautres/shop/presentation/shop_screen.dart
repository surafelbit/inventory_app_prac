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
  final TextEditingController productNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController partNoController = TextEditingController();
  final TextEditingController barCodeController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController minStockController = TextEditingController();
  final TextEditingController maxStockController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController variantController = TextEditingController();

  List<dynamic> myBranches = [];
  List<dynamic> shopBranches = [];
  String? selectedOption;
  bool hasManyBranches = false;
  bool gotoNext = false;
  bool addingContent = false;
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
      print('this got to be the user id');
      print(userRealId);
    } else {
      print('No user data found.');
    }
    print(user);
    try {
      final response = await ApiService.getInfoAboutMe(userRealId);
      final branches = response['branches'] ?? [];

      setState(() {
        myBranches = branches;
        shopBranches =
            myBranches.where((e) => e['houseType'] == 'SHOP').toList();
        if (shopBranches.length == 1) gotoNext = true;
        hasManyBranches = shopBranches.length > 1;
        if (shopBranches.isNotEmpty) selectedOption = shopBranches[0]['id'];
        // if (shopBranches.isNotEmpty && selectedOption == null)
        //   selectedOption = shopBranches[0]['id'];
      });
    } catch (error) {
      print(error);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarBuild(),
      //  AppBar(
      //   backgroundColor: Colors.white,
      //   title: shopBranches.length > 0
      //       ? SizedBox(
      //           width: double.infinity,
      //           height: 40,
      //           child: TextField(
      //             decoration: InputDecoration(
      //                 hintText: 'Search Items In Shop',
      //                 prefixIcon: Icon(
      //                   Icons.search,
      //                   color: Colors.grey,
      //                 ),
      //                 enabledBorder: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(12)),
      //                 focusedBorder: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(12),
      //                     borderSide:
      //                         BorderSide(color: Colors.blue, width: 1.5))),
      //           ))
      //       : CircularProgressIndicator(),
      // ),
      body:
          // (hasManyBranches )? CircularProgressIndicator():
          //      (SingleChildScrollView(
          //         child: Column(
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: [
          //                 Row(
          //                   children: [Text('filter'), Icon(Icons.filter_alt)],
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Row(
          //                   children: [Text('sort'), Icon(Icons.sort)],
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Row(
          //                   children: [Text('collection'), Icon(Icons.collections)],
          //                 ),
          //               ],
          //             ),
          //             Container(
          //               child: Padding(
          //                 padding: EdgeInsets.all(20),
          //                 child: Row(
          //                   children: [
          //                     const SizedBox(height: 15),
          //                     Text('first pick a shop'),
          //                     Expanded(
          //                       child: DropdownButtonFormField<String>(
          //                         value: selectedOption,
          //                         decoration: InputDecoration(
          //                           labelText: 'Select Branch',
          //                           border: OutlineInputBorder(
          //                             borderRadius: BorderRadius.circular(12),
          //                           ),
          //                           contentPadding: const EdgeInsets.symmetric(
          //                               horizontal: 16, vertical: 10),
          //                         ),
          //                         isExpanded: true,
          //                         selectedItemBuilder: (context) {
          //                           return shopBranches.map((shop) {
          //                             return Text(
          //                               shop['name'],
          //                               style: const TextStyle(
          //                                   fontWeight: FontWeight.bold),
          //                               overflow: TextOverflow.ellipsis,
          //                             );
          //                           }).toList();
          //                         },
          //                         items: shopBranches.map((shop) {
          //                           return DropdownMenuItem<String>(
          //                             value: shop['id'],
          //                             child: Row(
          //                               children: [
          //                                 CircleAvatar(
          //                                   radius: 15,
          //                                   backgroundColor: Colors.green,
          //                                   child: Icon(Icons.shop,
          //                                       size: 18, color: Colors.white),
          //                                 ),
          //                                 const SizedBox(width: 12),
          //                                 Expanded(
          //                                   child: Text(
          //                                     shop['name'],
          //                                     style: const TextStyle(
          //                                         fontWeight: FontWeight.bold),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           );
          //                         }).toList(),
          //                         onChanged: (String? newValue) {
          //                           setState(() {
          //                             selectedOption = newValue!;
          //                             hasManyBranches = false;
          //                           });
          //                         },
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       )),
          buildBody(),
      floatingActionButton: gotoNext
          ? FloatingActionButton.extended(
              onPressed: () async {
                try {
                  setState(() {
                    gotoNext = false;
                    addingContent = true;
                  });
                  // showModalBottomSheet(
                  //     context: context,
                  //     builder: (BuildContext modalContext) {
                  //       return StatefulBuilder(builder: (context, setState) {
                  //         return Container(
                  //           padding: EdgeInsets.all(12),
                  //           child: Column(
                  //             children: [
                  //               Text(
                  //                 'Select Branch',
                  //                 style: TextStyle(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //               const SizedBox(height: 16),
                  //               Expanded(
                  //                   child: ListView.builder(
                  //                       itemCount: shopBranches.length,
                  //                       itemBuilder: (context, index) {
                  //                         final name =
                  //                             shopBranches[index]['name'];
                  //                         final option =
                  //                             shopBranches[index]['id'];
                  //                         return RadioListTile(
                  //                             title: Text(name),
                  //                             value: option,
                  //                             groupValue: selectedOption,
                  //                             onChanged: (value) {
                  //                               setState(() {
                  //                                 selectedOption = value;
                  //                               });
                  //                             });
                  //                       }))
                  //             ],
                  //           ),
                  //         );
                  //       });
                  //       // return Padding(
                  //       //   padding: EdgeInsets.only(
                  //       //       left: 10, right: 10, top: 20, bottom: 40),
                  //       //   child: Column(
                  //       //     children: [
                  //       //       Text('Choose a branch to add a product to'),
                  //       //       SizedBox(height: 10),
                  //       //       DropdownButtonFormField(
                  //       //           value: 'data1',
                  //       //           items: const [
                  //       //             DropdownMenuItem(
                  //       //                 value: 'data1', child: Text('data')),
                  //       //             DropdownMenuItem(
                  //       //                 value: 'data2', child: Text('data')),
                  //       //             DropdownMenuItem(
                  //       //                 value: 'data3', child: Text('data')),
                  //       //           ],
                  //       //           selectedItemBuilder: (context) {
                  //       //             return const [Text('data')];
                  //       //           },
                  //       //           onChanged: (value) {})
                  //       //     ],
                  //       //   ),
                  //       // );
                  //     });
                } catch (error) {}
              },
              label: Text("Add Items To Shop"),
              icon: Icon(Icons.add),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }

  Widget buildBody() {
    if (shopBranches.isEmpty) {
      return CircularProgressIndicator();
    } else if (hasManyBranches) {
      return (SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // children: [
              //   Row(
              //     children: [Text('filter'), Icon(Icons.filter_alt)],
              //   ),
              //   SizedBox(
              //     width: 10,
              //   ),
              //   Row(
              //     children: [Text('sort'), Icon(Icons.sort)],
              //   ),
              //   SizedBox(
              //     width: 10,
              //   ),
              //   Row(
              //     children: [Text('collection'), Icon(Icons.collections)],
              //   ),
              // ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    const SizedBox(height: 15),
                    Text('first pick a shop'),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedOption,
                        decoration: InputDecoration(
                          labelText: 'Select Branch',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        isExpanded: true,
                        selectedItemBuilder: (context) {
                          return shopBranches.map((shop) {
                            return Text(
                              shop['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            );
                          }).toList();
                        },
                        items: shopBranches.map((shop) {
                          return DropdownMenuItem<String>(
                            value: shop['id'],
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.shop,
                                      size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    shop['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            gotoNext = true;
                            selectedOption = newValue!;
                            hasManyBranches = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ));
    } else if (gotoNext) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Text('Default content Man'),
          ],
        ),
      );
    } else if (addingContent) {
      return SingleChildScrollView(
          child: Container(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Organization Login",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: productNumberController,
                        decoration: InputDecoration(
                          labelText: 'product name',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descritption',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: partNoController,
                        decoration: InputDecoration(
                          labelText: 'Part Number',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: barCodeController,
                        decoration: InputDecoration(
                          labelText: 'Barcode',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: purchasePriceController,
                        decoration: InputDecoration(
                          labelText: 'Purchase Price',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: sellingPriceController,
                        decoration: InputDecoration(
                          labelText: 'Selling Price',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: minStockController,
                        decoration: InputDecoration(
                          labelText: 'Minimum Stock',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: maxStockController,
                        decoration: InputDecoration(
                          labelText: 'Maximum Stock',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: variantController,
                        decoration: InputDecoration(
                          labelText: 'Variant',
                          border: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(12),
                              ),
                        ),
                      ),
                    ),
                  ]),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text("Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return Center(child: Text('Nothing to show'));
  }

  PreferredSizeWidget TopBarBuild() {
    if (shopBranches.isEmpty) {
      return AppBar(
        title: Text('Loading your branches'),
        actions: [CircularProgressIndicator()],
      );
    } else if (hasManyBranches) {
      return AppBar(
        title: Text('Please select your branches'),
      );
    } else if (gotoNext) {
      return AppBar(
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
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                gotoNext = false;
                hasManyBranches = true;
              });
            },
          ),
        ],
      );
    } else if (addingContent) {
      return AppBar(
        title: Text('Adding Shop Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                addingContent = false;
                gotoNext = true;
              });
            },
          ),
        ],
      );
    } else {
      return AppBar(
        title: Text('Trying incase it fails'),
        actions: [CircularProgressIndicator()],
      );
    }
  }
}
