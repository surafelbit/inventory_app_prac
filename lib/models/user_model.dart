import 'dart:convert';
import 'branch_model.dart';
import 'organization_model.dart';
import 'permission_model.dart';

class UserModel {
  final String? id;
  final String name;
  final String? phone;
  final String userType;
  final BranchModel? branch;
  final OrganizationModel? organization;
  final List<PermissionModel>? permissions;
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.userType,
    required this.branch,
    required this.organization,
    required this.permissions,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['userType'] ?? '',
      branch: BranchModel.fromJson(json['branch'] ?? {}),
      organization: OrganizationModel.fromJson(json['organization'] ?? {}),
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .map((p) => PermissionModel.fromJson(p))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'userType': userType,
      'branch': branch?.toJson(),
      'organization': organization?.toJson(),
      'permissions': permissions?.map((p) => p.toJson()).toList(),
    };
  }

  static UserModel fromJsonString(String jsonString) =>
      UserModel.fromJson(jsonDecode(jsonString));

  String toJsonString() => jsonEncode(toJson());
}
