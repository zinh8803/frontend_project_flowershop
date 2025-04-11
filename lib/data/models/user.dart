class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? phoneNumber;
  final String? address;
  final bool isLoggedIn;
  final String lastLoginAt;
  final String createdAt;
  final String updatedAt;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phoneNumber,
    this.address,
    required this.isLoggedIn,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      isLoggedIn: json['is_logged_in'] == 1,
      lastLoginAt: json['last_login_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      token: token,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone_number': phoneNumber,
      'address': address,
      'is_logged_in': isLoggedIn ? 1 : 0,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'token': token,
    };
  }
}
