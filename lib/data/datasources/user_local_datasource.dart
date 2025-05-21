import 'package:mobile_android/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<bool> verifyCredentials(String email, String password);
  Future<void> setLoggedInFlag(bool loggedIn);
  Future<bool> isLoggedIn();
}


class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences prefs;

  UserLocalDataSourceImpl({required this.prefs});

  static const _nameKey = 'name';
  static const _emailKey = 'email';
  static const _passwordKey = 'password';
  static const _dobKey = 'dob';
  static const _isLoggedInKey = 'isLoggedIn';

  @override
  Future<void> cacheUser(UserModel user) async {
    await prefs.setString(_nameKey, user.name);
    await prefs.setString(_emailKey, user.email);
    await prefs.setString(_passwordKey, user.password);
    await prefs.setString(_dobKey, user.dob);
    await prefs.setBool(_isLoggedInKey, true);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final name = prefs.getString(_nameKey);
    final email = prefs.getString(_emailKey);
    final password = prefs.getString(_passwordKey);
    final dob = prefs.getString(_dobKey);
    if (name != null && email != null && password != null && dob != null) {
      return UserModel(
        name: name,
        email: email,
        password: password,
        dob: dob,
      );
    }
    return null;
  }

  @override
  Future<bool> verifyCredentials(String email, String password) async {
    final storedEmail = prefs.getString(_emailKey);
    final storedPassword = prefs.getString(_passwordKey);
    return storedEmail == email && storedPassword == password;
  }

  @override
  Future<bool> isLoggedIn() async {
    return prefs.getBool(_isLoggedInKey) ?? false;
  }


  @override
  Future<void> setLoggedInFlag(bool loggedIn) async {
    await prefs.setBool(_isLoggedInKey, loggedIn);
  }
}
