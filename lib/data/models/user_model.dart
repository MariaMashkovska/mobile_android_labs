import 'package:mobile_android/domain/entities/user.dart';

class UserModel extends User {
  final String password;

  UserModel({
    required super.name,
    required super.email,
    required this.password,
    required super.dob,
  });
}
