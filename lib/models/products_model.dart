class Product {
  final String name;
  final String? description;
  final String? partNo;
  final String? barcode;
  final double? sellingPrice;
  final double? purchasePrice;
  final double? minStock;
  final double? maxStock;
  final double quantity;
  final String? variant;
  Product(
      {required this.name,
      this.description,
      this.partNo,
      this.barcode,
      this.sellingPrice,
      this.purchasePrice,
      this.maxStock,
      this.minStock,
      required this.quantity,
      this.variant});

  factory Product.fromJson(Map<String, dynamic> json) {
    final productData = json['product'] ?? {};
    return Product(
      name: productData['name'],
      description: productData['description'],
      partNo: productData['partNo'],
      barcode: productData['barcode'],
      sellingPrice: parseDouble(productData['sellingPrice']),
      purchasePrice: parseDouble(productData['purchasePrice']),
      minStock: (json['minStock'] ?? 0).toDouble(),
      maxStock: (json['maxStock'] ?? 0).toDouble(),
      quantity: (json['quantity'] ?? 0).toDouble(),
      variant: productData['variant'],
    );
  }
}

double parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
