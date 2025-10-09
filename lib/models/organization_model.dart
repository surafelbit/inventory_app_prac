class OrganizationModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String registrationDate;
  final String expirationDate;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  OrganizationModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.registrationDate,
    required this.expirationDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      registrationDate: json['registrationDate'] ?? '',
      expirationDate: json['expirationDate'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'registrationDate': registrationDate,
      'expirationDate': expirationDate,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
