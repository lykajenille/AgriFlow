class User {
  int? id;
  String username;
  String? email;
  String? fullName;
  String role;

  User({
    this.id,
    required this.username,
    this.email,
    this.fullName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      username: json['username'] ?? '',
      email: json['email'],
      fullName: json['full_name'],
      role: json['role'] ?? 'farmer',
    );
  }

  bool isAdmin() {
    return role == "admin";
  }
}