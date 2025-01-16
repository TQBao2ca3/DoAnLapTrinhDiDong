class User {
  final int user_id;
  final String username;
  final String password;
  final String email;
  final String fullname;
  final String phone;

  User(
      {required this.user_id,
      required this.username,
      required this.password,
      required this.email,
      required this.fullname,
      required this.phone});

  //convert Map to dart object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        user_id: json['user_id'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        fullname: json['fullname'],
        phone: json['phone']);
  }

  //convert dart object to Map
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'username': username,
      'password': password,
      'email': email,
      'fullname': fullname,
      'phone': phone
    };
  }
}
