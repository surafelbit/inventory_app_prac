import 'dart:convert';

import 'organization_model.dart';

class AdminModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String userType;
  final String role;
  final OrganizationModel? organization;
  AdminModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.userType,
      required this.role,
      required this.organization});
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phone: json['phone'],
        userType: json['userType'],
        role: json['role'],
        organization: json['organization']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'userType': userType,
      'role': role,
      'organization': organization?.toJson(),
    };
  }

  static AdminModel fromJsonString(String jsonString) =>
      AdminModel.fromJson(jsonDecode(jsonString));

  String toJsonString() => jsonEncode(toJson());
}
