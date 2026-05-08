class Party {
  final String id;
  final String name;
  final String? phone;
  final int colorIndex;
  final DateTime createdAt;

  Party({
    required this.id,
    required this.name,
    this.phone,
    required this.colorIndex,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'color_index': colorIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Party.fromMap(Map<String, dynamic> map) {
    return Party(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      colorIndex: map['color_index'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
