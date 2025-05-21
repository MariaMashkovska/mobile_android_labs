import 'package:mobile_android/data/datasources/user_local_datasource.dart';
import 'package:mobile_android/data/models/user_model.dart';
import 'package:mobile_android/domain/entities/user.dart';
import 'package:mobile_android/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String dob,
  }) async {
    final user = UserModel(
      name: name,
      email: email,
      password: password,
      dob: dob,
    );
    await localDataSource.cacheUser(user);
  }

  @override
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final success = await localDataSource.verifyCredentials(email, password);
    if (success) {
      await localDataSource.setLoggedInFlag(true);
    }
    return success;
  }

  @override
  Future<void> logout() async {
    await localDataSource.setLoggedInFlag(false); // тільки прапорець
  }

  @override
  Future<User?> getCurrentUser() async {
    final loggedIn = await localDataSource.isLoggedIn();
    if (!loggedIn) return null;
    return localDataSource.getCachedUser();
  }

  @override
  Future<void> updateProfile(User user) async {
    final current = await localDataSource.getCachedUser();
    if (current != null) {
      final updated = UserModel(
        name: user.name,
        email: user.email,
        password: current.password,
        dob: user.dob,
      );
      await localDataSource.cacheUser(updated);
    }
  }


  @override
  Future<void> setLoggedIn(bool loggedIn) {
    return localDataSource.setLoggedInFlag(loggedIn);
  }
}
