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
  List<dynamic> products = [];
  bool productsLoading = true;
  List<dynamic> shopBranches = [];
  String? selectedOption;
  bool hasManyBranches = false;
  bool gotoNext = false;
  bool addingContent = false;

  @override
  void initState() {
    super.initState();
    getInfoAboutMe();
    getProducts();
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
      productsLoading = false;
    } catch (error) {
      print(error);
      productsLoading = false;
    }
  }

  Future<void> getProducts() async {
    try {
      final response = await ApiService.getProducts();
      print('this are the responses of the products $response');
      products = response;
    } catch (error) {
      print(error);
    }
  }

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
                //
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
          Column(
            children: products.map((product) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Name'),
                          Text('Selling Price'),
                          Text('Purchase Price'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(product['product']['name']),
                          Text(product['product']['sellingPrice']),
                          Text(product['product']['purchasePrice']),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: products.map((product) {
                  return SizedBox(
                    width: 160,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['product']['name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text(
                                'Selling: ${product['product']['sellingPrice']}'),
                            Text(
                                'Purchase: ${product['product']['purchasePrice']}'),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Tap + to add new products",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [],
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.shop),
                    title: Text(product['product']['name']),
                  ),
                );
              })
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
                          selectedOption!,
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
