class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final Property property;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.property,
  });
}

class Property {
  final String id;
  final String name;
  final String unit;

  Property({
    required this.id,
    required this.name,
    required this.unit,
  });

  String get fullAddress => '$name, $unit';
}

