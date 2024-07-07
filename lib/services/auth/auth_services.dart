import 'package:dalell/services/auth/auth_provider.dart';
import 'package:dalell/services/auth/auth_user.dart';

class AuthServices implements AuthProvider {
  final AuthProvider provider;

  const AuthServices({required this.provider});

  @override
  Future<AuthUser> createUsre({
    required String email,
    required String password,
  }) =>
      provider.createUsre(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
