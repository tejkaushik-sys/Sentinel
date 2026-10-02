class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String phone;
  final bool isPro;
  final String homeAddress;
  final String workAddress;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.phone,
    this.isPro = false,
    required this.homeAddress,
    required this.workAddress,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Mahi',
      email: json['email'] ?? 'mahi@kiit.ac.in',
      avatarUrl: json['avatar_url'] ?? '',
      phone: json['phone'] ?? '',
      isPro: json['is_pro'] ?? false,
      homeAddress: json['home_address'] ?? 'Patia, Bhubaneswar',
      workAddress: json['work_address'] ?? 'KIIT University Campus 6',
    );
  }
}

class SavedPlaceModel {
  final String id;
  final String name;
  final String label;
  final String address;
  final double latitude;
  final double longitude;

  SavedPlaceModel({
    required this.id,
    required this.name,
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory SavedPlaceModel.fromJson(Map<String, dynamic> json) {
    return SavedPlaceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      label: json['label'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 20.3547,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 85.8155,
    );
  }
}

class TrustedContactModel {
  final String id;
  final String name;
  final String phone;
  final String relationship;
  final bool isActive;

  TrustedContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
    this.isActive = true,
  });

  factory TrustedContactModel.fromJson(Map<String, dynamic> json) {
    return TrustedContactModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      relationship: json['relationship'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}
