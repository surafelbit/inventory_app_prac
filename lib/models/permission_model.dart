class PermissionModel {
  final String id;
  final String workerId;
  final String permissionId;
  final bool isGranted;
  final String grantedBy;
  final String grantedAt;
  final String updatedAt;
  final PermissionDetail permission;

  PermissionModel({
    required this.id,
    required this.workerId,
    required this.permissionId,
    required this.isGranted,
    required this.grantedBy,
    required this.grantedAt,
    required this.updatedAt,
    required this.permission,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] ?? '',
      workerId: json['workerId'] ?? '',
      permissionId: json['permissionId'] ?? '',
      isGranted: json['isGranted'] ?? false,
      grantedBy: json['grantedBy'] ?? '',
      grantedAt: json['grantedAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      permission: PermissionDetail.fromJson(json['permission'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workerId': workerId,
      'permissionId': permissionId,
      'isGranted': isGranted,
      'grantedBy': grantedBy,
      'grantedAt': grantedAt,
      'updatedAt': updatedAt,
      'permission': permission.toJson(),
    };
  }
}

class PermissionDetail {
  final String id;
  final String name;
  final String description;
  final String category;
  final String createdAt;
  final String updatedAt;

  PermissionDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PermissionDetail.fromJson(Map<String, dynamic> json) {
    return PermissionDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
