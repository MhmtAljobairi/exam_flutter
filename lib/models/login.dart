class Login {
  String type;
  String token;
  Login(this.type, this.token);

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(json['type'], json['token']);
  }
}
