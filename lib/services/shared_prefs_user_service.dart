import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'user_service.dart';

class SharedPrefsUserService implements UserService {
  final SharedPreferences prefs;

  SharedPrefsUserService(this.prefs);

  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';
  static const String _keyDob = 'dob';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  @override
  Future<void> registerUser(User user) async {
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyPassword, user.password);
    await prefs.setString(_keyDob, user.dob);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  @override
  Future<User?> getUser() async {
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);
    final password = prefs.getString(_keyPassword);
    final dob = prefs.getString(_keyDob);

    if (name != null && email != null && password != null && dob != null) {
      return User(name: name, email: email, password: password, dob: dob);
    }
    return null;
  }

  @override
  Future<bool> loginUser(String email, String password) async {
    final storedEmail = prefs.getString(_keyEmail);
    final storedPassword = prefs.getString(_keyPassword);

    if (email == storedEmail && password == storedPassword) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    return false;
  }

  @override
  Future<void> logoutUser() async {
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  @override
  Future<void> updateUser(User user) async {
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyPassword, user.password);
    await prefs.setString(_keyDob, user.dob);
  }

  @override
  Future<void> deleteUser() async {
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyDob);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  @override
  Future<bool> isLoggedIn() async {
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
