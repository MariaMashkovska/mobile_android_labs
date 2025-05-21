import 'package:mobile_android/domain/entities/user.dart';

abstract class AuthRepository {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String dob,
  });

  Future<bool> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();

  Future<void> updateProfile(User user);

  Future<void> setLoggedIn(bool loggedIn);
}
