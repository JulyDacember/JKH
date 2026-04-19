enum UserRole { resident, admin }

extension UserRoleX on UserRole {
  String get storageValue {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.resident:
        return 'resident';
    }
  }

  static UserRole fromStorageValue(String? value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.resident;
    }
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final Property property;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.property,
    this.role = UserRole.resident,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      property: Property.fromJson(
        (json['property'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      role: UserRoleX.fromStorageValue(json['role']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'property': property.toJson(),
      'role': role.storageValue,
    };
  }
}

class Property {
  final String id;
  final String name;
  final String unit;

  Property({required this.id, required this.name, required this.unit});

  String get fullAddress => '$name, $unit';

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      unit: (json['unit'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'unit': unit};
  }
}
