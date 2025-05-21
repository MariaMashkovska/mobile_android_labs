class User {
  final String name;
  final String email;
  final String password;
  final String dob;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.dob,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'dob': dob,
    };
  }

  factory User.fromMap(Map<String, String> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      dob: map['dob'] ?? '',
    );
  }
}
