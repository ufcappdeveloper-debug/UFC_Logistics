class User {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? profileImage;
  final List<Station>? stations;

  User({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.stations,
  });

  // Factory method to create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    final driver = json['driver'] as Map<String, dynamic>?;
    if (driver == null) {
      throw Exception("Missing 'driver' key in the response");
    }

    return User(
      id: int.tryParse((driver['id'] ?? '').toString()),
      fullName: driver['full_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: driver['phone_number'] as String?,
      profileImage: driver['profile_image'] as String?,
      stations: driver['stations'] != null
          ? (driver['stations'] as List)
              .map((x) => Station.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'driver': {
        'id': id,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'profile_image': profileImage,
        'stations': stations?.map((x) => x.toJson()).toList(),
      },
    };
  }
}

class Station {
  final int id;
  final String name;

  Station({required this.id, required this.name});

  // Factory method to create a Station instance from JSON
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as int,
      name: json['name_en'] as String,
    );
  }

  // Method to convert Station instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': name,
    };
  }
}

class UserAutoLogin {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String? verifiedAt;
  final String? verificationToken;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? token;

  UserAutoLogin({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    this.verifiedAt,
    this.verificationToken,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  // Factory method to create a User instance from JSON
  factory UserAutoLogin.fromJson(Map<String, dynamic> json) {
    return UserAutoLogin(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_image'],
      verifiedAt: json['verified_at'],
      verificationToken: json['verification_token'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      token: json['token'],
    );
  }

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'verified_at': verifiedAt,
      'verification_token': verificationToken,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'token': token,
    };
  }
}
