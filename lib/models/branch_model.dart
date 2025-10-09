class BranchModel {
  final String id;
  final String name;
  final String address;
  final String houseType;
  final String organizationId;
  final String createdAt;
  final String updatedAt;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.houseType,
    required this.organizationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      houseType: json['houseType'] ?? '',
      organizationId: json['organizationId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'houseType': houseType,
      'organizationId': organizationId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
