import '../models/user.dart';

abstract class UserService {
  Future<void> registerUser(User user);
  Future<User?> getUser();
  Future<bool> loginUser(String email, String password);
  Future<void> logoutUser();
  Future<void> updateUser(User user);
  Future<void> deleteUser();
  Future<bool> isLoggedIn();
}
