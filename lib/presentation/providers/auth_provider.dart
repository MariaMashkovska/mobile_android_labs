import 'package:flutter/material.dart';
import 'package:mobile_android/core/utils/validators.dart';
import 'package:mobile_android/domain/entities/user.dart';
import 'package:mobile_android/domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  User? _user;
  String? _error;

  AuthProvider(this._repo);

  User? get user => _user;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> loadUser() async {
    _user = await _repo.getCurrentUser();
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String dob,
  }) async {
    if (!Validators.isValidName(name)) {
      _error = 'The name must not contain numbers.';
      notifyListeners();
      return false;
    }
    if (!Validators.isValidEmail(email)) {
      _error = 'Incorrect mail format';
      notifyListeners();
      return false;
    }
    if (!Validators.isValidPassword(password)) {
      _error = 'Password must be at least 4 characters long.';
      notifyListeners();
      return false;
    }

    _error = null;

    await _repo.register(
      name: name,
      email: email,
      password: password,
      dob: dob,
    );

    return await login(email: email, password: password);
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final ok = await _repo.login(email: email, password: password);
    if (!ok) {
      _error = 'Invalid login details.';
      notifyListeners();
      return false;
    }

    _error = null;
    await _repo.setLoggedIn(true);
    await loadUser();
    return true;
  }

  Future<void> logout() async {
    await _repo.logout();
    await _repo.setLoggedIn(false);
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String dob,
  }) async {
    final updated = User(name: name, email: email, dob: dob);
    await _repo.updateProfile(updated);
    await loadUser();
  }


}
