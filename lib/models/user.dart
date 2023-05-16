class User {
  String username;
  String email;
  String? password;

  User({
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json['username'], email: json['email']);
  }
}
