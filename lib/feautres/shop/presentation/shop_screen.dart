// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_app/services/api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';

// class ShopScreen extends ConsumerStatefulWidget {
//   const ShopScreen({Key? Key}) : super(key: Key);
//   @override
//   _ShopScreenState createState() => _ShopScreenState();
// }

// class _ShopScreenState extends ConsumerState<ShopScreen> {
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController partNoController = TextEditingController();
//   final TextEditingController barCodeController = TextEditingController();
//   final TextEditingController purchasePriceController = TextEditingController();
//   final TextEditingController sellingPriceController = TextEditingController();
//   final TextEditingController minStockController = TextEditingController();
//   final TextEditingController maxStockController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController variantController = TextEditingController();
//   @override
//   void dispose() {
//     // Always dispose controllers
//     productNameController.dispose();
//     descriptionController.dispose();
//     partNoController.dispose();
//     barCodeController.dispose();
//     purchasePriceController.dispose();
//     sellingPriceController.dispose();
//     minStockController.dispose();
//     maxStockController.dispose();
//     quantityController.dispose();
//     variantController.dispose();
//     super.dispose();
//   }

//   List<dynamic> myBranches = [];
//   List<dynamic> shopBranches = [];
//   String? selectedOption;
//   bool hasManyBranches = false;
//   bool gotoNext = false;
//   bool addingContent = false;
//   @override
//   void initState() {
//     super.initState();
//     getInfoAboutMe();
//   }

//   Future<void> getInfoAboutMe() async {
//     final prefs = await SharedPreferences.getInstance();
//     final user = prefs.getString('user');
//     print('this is the user id or something');
//     final userString = prefs.getString('user');
//     String userRealId = '';
//     if (userString != null) {
//       userRealId = jsonDecode(userString)['id'];
//       print('this got to be the user id');
//       print(userRealId);
//     } else {
//       print('No user data found.');
//     }
//     print(user);
//     try {
//       final response = await ApiService.getInfoAboutMe(userRealId);
//       final branches = response['branches'] ?? [];

//       setState(() {
//         myBranches = branches;
//         shopBranches =
//             myBranches.where((e) => e['houseType'] == 'SHOP').toList();
//         if (shopBranches.length == 1) gotoNext = true;
//         hasManyBranches = shopBranches.length > 1;
//         if (shopBranches.isNotEmpty) selectedOption = shopBranches[0]['id'];
//         // if (shopBranches.isNotEmpty && selectedOption == null)
//         //   selectedOption = shopBranches[0]['id'];
//       });
//     } catch (error) {
//       print(error);
//     }
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TopBarBuild(),
//       //  AppBar(
//       //   backgroundColor: Colors.white,
//       //   title: shopBranches.length > 0
//       //       ? SizedBox(
//       //           width: double.infinity,
//       //           height: 40,
//       //           child: TextField(
//       //             decoration: InputDecoration(
//       //                 hintText: 'Search Items In Shop',
//       //                 prefixIcon: Icon(
//       //                   Icons.search,
//       //                   color: Colors.grey,
//       //                 ),
//       //                 enabledBorder: OutlineInputBorder(
//       //                     borderRadius: BorderRadius.circular(12)),
//       //                 focusedBorder: OutlineInputBorder(
//       //                     borderRadius: BorderRadius.circular(12),
//       //                     borderSide:
//       //                         BorderSide(color: Colors.blue, width: 1.5))),
//       //           ))
//       //       : CircularProgressIndicator(),
//       // ),
//       body:
//           // (hasManyBranches )? CircularProgressIndicator():
//           //      (SingleChildScrollView(
//           //         child: Column(
//           //           children: [
//           //             Row(
//           //               mainAxisAlignment: MainAxisAlignment.spaceAround,
//           //               children: [
//           //                 Row(
//           //                   children: [Text('filter'), Icon(Icons.filter_alt)],
//           //                 ),
//           //                 SizedBox(
//           //                   width: 10,
//           //                 ),
//           //                 Row(
//           //                   children: [Text('sort'), Icon(Icons.sort)],
//           //                 ),
//           //                 SizedBox(
//           //                   width: 10,
//           //                 ),
//           //                 Row(
//           //                   children: [Text('collection'), Icon(Icons.collections)],
//           //                 ),
//           //               ],
//           //             ),
//           //             Container(
//           //               child: Padding(
//           //                 padding: EdgeInsets.all(20),
//           //                 child: Row(
//           //                   children: [
//           //                     const SizedBox(height: 15),
//           //                     Text('first pick a shop'),
//           //                     Expanded(
//           //                       child: DropdownButtonFormField<String>(
//           //                         value: selectedOption,
//           //                         decoration: InputDecoration(
//           //                           labelText: 'Select Branch',
//           //                           border: OutlineInputBorder(
//           //                             borderRadius: BorderRadius.circular(12),
//           //                           ),
//           //                           contentPadding: const EdgeInsets.symmetric(
//           //                               horizontal: 16, vertical: 10),
//           //                         ),
//           //                         isExpanded: true,
//           //                         selectedItemBuilder: (context) {
//           //                           return shopBranches.map((shop) {
//           //                             return Text(
//           //                               shop['name'],
//           //                               style: const TextStyle(
//           //                                   fontWeight: FontWeight.bold),
//           //                               overflow: TextOverflow.ellipsis,
//           //                             );
//           //                           }).toList();
//           //                         },
//           //                         items: shopBranches.map((shop) {
//           //                           return DropdownMenuItem<String>(
//           //                             value: shop['id'],
//           //                             child: Row(
//           //                               children: [
//           //                                 CircleAvatar(
//           //                                   radius: 15,
//           //                                   backgroundColor: Colors.green,
//           //                                   child: Icon(Icons.shop,
//           //                                       size: 18, color: Colors.white),
//           //                                 ),
//           //                                 const SizedBox(width: 12),
//           //                                 Expanded(
//           //                                   child: Text(
//           //                                     shop['name'],
//           //                                     style: const TextStyle(
//           //                                         fontWeight: FontWeight.bold),
//           //                                   ),
//           //                                 ),
//           //                               ],
//           //                             ),
//           //                           );
//           //                         }).toList(),
//           //                         onChanged: (String? newValue) {
//           //                           setState(() {
//           //                             selectedOption = newValue!;
//           //                             hasManyBranches = false;
//           //                           });
//           //                         },
//           //                       ),
//           //                     )
//           //                   ],
//           //                 ),
//           //               ),
//           //             )
//           //           ],
//           //         ),
//           //       )),
//           buildBody(),
//       floatingActionButton: gotoNext
//           ? FloatingActionButton.extended(
//               onPressed: () async {
//                 try {
//                   setState(() {
//                     gotoNext = false;
//                     addingContent = true;
//                   });
//                   // showModalBottomSheet(
//                   //     context: context,
//                   //     builder: (BuildContext modalContext) {
//                   //       return StatefulBuilder(builder: (context, setState) {
//                   //         return Container(
//                   //           padding: EdgeInsets.all(12),
//                   //           child: Column(
//                   //             children: [
//                   //               Text(
//                   //                 'Select Branch',
//                   //                 style: TextStyle(
//                   //                     fontSize: 18,
//                   //                     fontWeight: FontWeight.bold),
//                   //               ),
//                   //               const SizedBox(height: 16),
//                   //               Expanded(
//                   //                   child: ListView.builder(
//                   //                       itemCount: shopBranches.length,
//                   //                       itemBuilder: (context, index) {
//                   //                         final name =
//                   //                             shopBranches[index]['name'];
//                   //                         final option =
//                   //                             shopBranches[index]['id'];
//                   //                         return RadioListTile(
//                   //                             title: Text(name),
//                   //                             value: option,
//                   //                             groupValue: selectedOption,
//                   //                             onChanged: (value) {
//                   //                               setState(() {
//                   //                                 selectedOption = value;
//                   //                               });
//                   //                             });
//                   //                       }))
//                   //             ],
//                   //           ),
//                   //         );
//                   //       });
//                   //       // return Padding(
//                   //       //   padding: EdgeInsets.only(
//                   //       //       left: 10, right: 10, top: 20, bottom: 40),
//                   //       //   child: Column(
//                   //       //     children: [
//                   //       //       Text('Choose a branch to add a product to'),
//                   //       //       SizedBox(height: 10),
//                   //       //       DropdownButtonFormField(
//                   //       //           value: 'data1',
//                   //       //           items: const [
//                   //       //             DropdownMenuItem(
//                   //       //                 value: 'data1', child: Text('data')),
//                   //       //             DropdownMenuItem(
//                   //       //                 value: 'data2', child: Text('data')),
//                   //       //             DropdownMenuItem(
//                   //       //                 value: 'data3', child: Text('data')),
//                   //       //           ],
//                   //       //           selectedItemBuilder: (context) {
//                   //       //             return const [Text('data')];
//                   //       //           },
//                   //       //           onChanged: (value) {})
//                   //       //     ],
//                   //       //   ),
//                   //       // );
//                   //     });
//                 } catch (error) {}
//               },
//               label: Text("Add Items To Shop"),
//               icon: Icon(Icons.add),
//               backgroundColor: Colors.green,
//             )
//           : null,
//     );
//   }

//   Widget buildBody() {
//     if (shopBranches.isEmpty) {
//       return CircularProgressIndicator();
//     } else if (hasManyBranches) {
//       return (SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               // children: [
//               //   Row(
//               //     children: [Text('filter'), Icon(Icons.filter_alt)],
//               //   ),
//               //   SizedBox(
//               //     width: 10,
//               //   ),
//               //   Row(
//               //     children: [Text('sort'), Icon(Icons.sort)],
//               //   ),
//               //   SizedBox(
//               //     width: 10,
//               //   ),
//               //   Row(
//               //     children: [Text('collection'), Icon(Icons.collections)],
//               //   ),
//               // ],
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
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
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
//                             gotoNext = true;
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
//       ));
//     } else if (gotoNext) {
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             Text('Default content Man'),
//           ],
//         ),
//       );
//     } else if (addingContent) {
//       return SingleChildScrollView(
//           child: Container(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 16),
//                   const Text(
//                     "Organization Login",
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(children: [
//                     Expanded(
//                       child: TextField(
//                         controller: productNameController,
//                         decoration: InputDecoration(
//                           labelText: 'product name',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: descriptionController,
//                         decoration: InputDecoration(
//                           labelText: 'Descritption',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                   ]),
//                   const SizedBox(height: 16),
//                   Row(children: [
//                     Expanded(
//                       child: TextField(
//                         controller: partNoController,
//                         decoration: InputDecoration(
//                           labelText: 'Part Number',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: barCodeController,
//                         decoration: InputDecoration(
//                           labelText: 'Barcode',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                   ]),
//                   const SizedBox(height: 16),
//                   Row(children: [
//                     Expanded(
//                       child: TextField(
//                         controller: purchasePriceController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(
//                               r'^\d*\.?\d*')), // allow digits + optional dot
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Purchase Price',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: sellingPriceController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(
//                               r'^\d*\.?\d*')), // allow digits + optional dot
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Selling Price',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                   ]),
//                   const SizedBox(height: 16),
//                   Row(children: [
//                     Expanded(
//                       child: TextField(
//                         controller: minStockController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(
//                               r'^\d*\.?\d*')), // allow digits + optional dot
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Minimum Stock',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: maxStockController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(
//                               r'^\d*\.?\d*')), // allow digits + optional dot
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Maximum Stock',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                   ]),
//                   const SizedBox(height: 16),
//                   Row(children: [
//                     Expanded(
//                       child: TextField(
//                         controller: quantityController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(
//                               r'^\d*\.?\d*')), // allow digits + optional dot
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Quantity',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: variantController,
//                         decoration: InputDecoration(
//                           labelText: 'Variant',
//                           border: OutlineInputBorder(
//                               //borderRadius: BorderRadius.circular(12),
//                               ),
//                         ),
//                       ),
//                     ),
//                   ]),
//                   OutlinedButton(
//                     onPressed: () async {
//                       String productName = productNameController.text;
//                       String description = descriptionController.text;
//                       String partNo = partNoController.text;
//                       int? minStock =
//                           int.tryParse(minStockController.text) ?? 0;
//                       int? maxStock =
//                           int.tryParse(maxStockController.text) ?? 0;
//                       String variant = variantController.text;
//                       double? sellingPrice =
//                           double.tryParse(sellingPriceController.text) ?? 0.0;
//                       double? purchasePrice =
//                           double.tryParse(purchasePriceController.text) ?? 0.0;
//                       int? quantity =
//                           int.tryParse(quantityController.text) ?? 0;
//                       String barcode = barCodeController.text;
//                       try {
//                         print(partNo);
//                         print(
//                             'this above me is partno $partNo productname $productName quantity $quantity');
//                         final response = await ApiService.addProducts(
//                             productName,
//                             partNo,
//                             barcode,
//                             purchasePrice,
//                             sellingPrice,
//                             minStock,
//                             maxStock,
//                             "cmgqlcf7m0001l98wecsaz98e",
//                             variant,
//                             "location",
//                             quantity);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text('success'),
//                           duration: Duration(seconds: 3),
//                         ));
//                       } catch (error) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text('error'),
//                           duration: Duration(seconds: 3),
//                         ));
//                       }
//                     },
//                     child: Text("Register"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ));
//     }
//     return Center(child: Text('Nothing to show'));
//   }

//   PreferredSizeWidget TopBarBuild() {
//     if (shopBranches.isEmpty) {
//       return AppBar(
//         title: Text('Loading your branches'),
//         actions: [CircularProgressIndicator()],
//       );
//     } else if (hasManyBranches) {
//       return AppBar(
//         title: Text('Please select your branches'),
//       );
//     } else if (gotoNext) {
//       return AppBar(
//         backgroundColor: Colors.white,
//         title: SizedBox(
//             width: double.infinity,
//             height: 40,
//             child: TextField(
//               decoration: InputDecoration(
//                   hintText: 'Search Items In Shop',
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Colors.grey,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.blue, width: 1.5))),
//             )),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               setState(() {
//                 gotoNext = false;
//                 hasManyBranches = true;
//               });
//             },
//           ),
//         ],
//       );
//     } else if (addingContent) {
//       return AppBar(
//         title: Text('Adding Shop Items'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               setState(() {
//                 addingContent = false;
//                 gotoNext = true;
//               });
//             },
//           ),
//         ],
//       );
//     } else {
//       return AppBar(
//         title: Text('Trying incase it fails'),
//         actions: [CircularProgressIndicator()],
//       );
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with TickerProviderStateMixin {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController partNoController = TextEditingController();
  final TextEditingController barCodeController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController minStockController = TextEditingController();
  final TextEditingController maxStockController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController variantController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    partNoController.dispose();
    barCodeController.dispose();
    purchasePriceController.dispose();
    sellingPriceController.dispose();
    minStockController.dispose();
    maxStockController.dispose();
    quantityController.dispose();
    variantController.dispose();
    super.dispose();
  }

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
    final userString = prefs.getString('user');
    String userRealId = '';
    if (userString != null) {
      userRealId = jsonDecode(userString)['id'];
    }

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
      });
    } catch (error) {
      print(error);
    }
  }

//touch the sky
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TopBarBuild(),
      body: buildBody(),
      floatingActionButton: gotoNext
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  gotoNext = false;
                  addingContent = true;
                });
              },
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              label: const Text(
                "Add Items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.add, size: 20),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildBody() {
    if (shopBranches.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      );
    } else if (hasManyBranches) {
      return _buildBranchSelection();
    } else if (gotoNext) {
      return _buildShopDashboard();
    } else if (addingContent) {
      return _buildAddProductForm();
    }
    return const Center(child: Text('Nothing to show'));
  }

  Widget _buildBranchSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Your Shop",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedOption,
                decoration: InputDecoration(
                  labelText: 'Choose Branch',
                  prefixIcon: const Icon(Icons.store, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                items: shopBranches.map((shop) {
                  return DropdownMenuItem<String>(
                    value: shop['id'],
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue.shade600,
                          child: const Icon(Icons.shop,
                              size: 16, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            shop['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Welcome to Your Shop",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    shopBranches
                        .firstWhere((e) => e['id'] == selectedOption)['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Tap + to add new products",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductForm() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Add New Product",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextFieldRow(
                  productNameController,
                  "Product Name",
                  Icons.inventory_2,
                ),
                const SizedBox(height: 16),
                _buildTextFieldRow(
                  descriptionController,
                  "Description",
                  Icons.description,
                ),
                const SizedBox(height: 16),
                _buildTextFieldRow(
                  partNoController,
                  "Part Number",
                  Icons.tag,
                ),
                const SizedBox(height: 16),
                _buildTextFieldRow(
                  barCodeController,
                  "Barcode",
                  Icons.qr_code,
                ),
                const SizedBox(height: 16),
                _buildPriceRow(
                  purchasePriceController,
                  sellingPriceController,
                  "Purchase Price",
                  "Selling Price",
                ),
                const SizedBox(height: 16),
                _buildPriceRow(
                  minStockController,
                  maxStockController,
                  "Min Stock",
                  "Max Stock",
                  isInteger: true,
                ),
                const SizedBox(height: 16),
                _buildPriceRow(
                  quantityController,
                  variantController,
                  "Quantity",
                  "Variant",
                  isInteger: true,
                  variant: true,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String productName = productNameController.text;
                      String description = descriptionController.text;
                      String partNo = partNoController.text;
                      int? minStock =
                          int.tryParse(minStockController.text) ?? 0;
                      int? maxStock =
                          int.tryParse(maxStockController.text) ?? 0;
                      String variant = variantController.text;
                      double? sellingPrice =
                          double.tryParse(sellingPriceController.text) ?? 0.0;
                      double? purchasePrice =
                          double.tryParse(purchasePriceController.text) ?? 0.0;
                      int? quantity =
                          int.tryParse(quantityController.text) ?? 0;
                      String barcode = barCodeController.text;

                      try {
                        final response = await ApiService.addProducts(
                          productName,
                          partNo,
                          barcode,
                          purchasePrice,
                          sellingPrice,
                          minStock,
                          maxStock,
                          "cmgqlcf7m0001l98wecsaz98e",
                          variant,
                          "location",
                          quantity,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product added successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() {
                          addingContent = false;
                          gotoNext = true;
                        });
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to add product'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Register Product",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldRow(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isInteger = false,
    bool variant = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: isInteger
                ? TextInputType.number
                : (variant ? TextInputType.text : TextInputType.text),
            inputFormatters: isInteger
                ? [FilteringTextInputFormatter.digitsOnly]
                : (controller == purchasePriceController ||
                        controller == sellingPriceController)
                    ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                    : null,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: Colors.blue),
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    TextEditingController controller1,
    TextEditingController controller2,
    String label1,
    String label2, {
    bool isInteger = false,
    bool variant = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildTextFieldRow(controller1, label1, Icons.attach_money,
              isInteger: isInteger),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: variant
              ? _buildTextFieldRow(controller2, label2, Icons.category)
              : _buildTextFieldRow(controller2, label2, Icons.sell,
                  isInteger: isInteger),
        ),
      ],
    );
  }

  PreferredSizeWidget TopBarBuild() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue.shade700,
      elevation: 2,
      centerTitle: true,
      title: Builder(
        builder: (context) {
          if (shopBranches.isEmpty) {
            return const Text("Loading Branches...");
          } else if (hasManyBranches) {
            return const Text("Select Shop");
          } else if (gotoNext) {
            return SizedBox(
              height: 44,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search items in shop",
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                ),
              ),
            );
          } else if (addingContent) {
            return const Text("Add Product");
          } else {
            return const Text("Shop");
          }
        },
      ),
      actions: [
        if (gotoNext || addingContent)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              setState(() {
                if (addingContent) {
                  addingContent = false;
                  gotoNext = true;
                } else if (gotoNext) {
                  gotoNext = false;
                  hasManyBranches = true;
                }
              });
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
