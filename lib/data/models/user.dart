class UserModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final String? avatar;
  final String? phoneNumber;
  final String? address;
  final bool? isLoggedIn;
  final String? lastLoginAt;
  final String createdAt;
  final String updatedAt;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatar,
    this.phoneNumber,
    this.address,
    required this.isLoggedIn,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      avatar: json['avatar'],
      phoneNumber:
          json['phone_number'] == null ? '' : json['phone_number'].toString(),
      address: json['address'] == null ? '' : json['address'].toString(),
      isLoggedIn: json['is_logged_in'],
      lastLoginAt: json['last_login_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      token: token,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatar': avatar,
      'phone_number': phoneNumber == null ? '' : phoneNumber.toString(),
      'address': address == null ? '' : address.toString(),
      'is_logged_in': isLoggedIn,
      'last_login_at': lastLoginAt ?? '',
      'created_at': createdAt,
      'updated_at': updatedAt,
      'token': token,
    };
  }
}
