class Vehicle {
  final String id;
  final String name;
  final String fuelType;
  final String? make;
  final String? model;
  final int? year;
  final String? vin;
  final String? licensePlate;
  final String? tireSizeStock;
  final String? tireSizeRunning;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Vehicle({
    required this.id,
    required this.name,
    required this.fuelType,
    this.make,
    this.model,
    this.year,
    this.vin,
    this.licensePlate,
    this.tireSizeStock,
    this.tireSizeRunning,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating from JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      name: json['name'] as String,
      fuelType: json['fuelType'] as String,
      make: json['make'] as String?,
      model: json['model'] as String?,
      year: json['year'] as int?,
      vin: json['vin'] as String?,
      licensePlate: json['licensePlate'] as String?,
      tireSizeStock: json['tireSizeStock'] as String?,
      tireSizeRunning: json['tireSizeRunning'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fuelType': fuelType,
      'make': make,
      'model': model,
      'year': year,
      'vin': vin,
      'licensePlate': licensePlate,
      'tireSizeStock': tireSizeStock,
      'tireSizeRunning': tireSizeRunning,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for creating modified instances
  Vehicle copyWith({
    String? id,
    String? name,
    String? fuelType,
    String? make,
    String? model,
    int? year,
    String? vin,
    String? licensePlate,
    String? tireSizeStock,
    String? tireSizeRunning,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      fuelType: fuelType ?? this.fuelType,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      vin: vin ?? this.vin,
      licensePlate: licensePlate ?? this.licensePlate,
      tireSizeStock: tireSizeStock ?? this.tireSizeStock,
      tireSizeRunning: tireSizeRunning ?? this.tireSizeRunning,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
