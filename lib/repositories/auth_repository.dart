import 'package:test_1/services/api_service.dart';
import 'package:test_1/services/token_service.dart';

class AuthRepository {
  final TokenService tokenService;
  final AuthService authService;

  AuthRepository({required this.tokenService, required this.authService});

  Future<bool> isAuthenticated() async {
    final access = tokenService.accessToken;
    final refresh = tokenService.refreshToken;
    final expiry = tokenService.expiryTime;

    if (access == null || refresh == null) {
      return false;
    }
    if (expiry != null) {
      final expiryDate = DateTime.parse(expiry);
      if (DateTime.now().isAfter(expiryDate)) {
        final newToken = await authService.refreshAccessToken(refresh);
        if (newToken == null) {
          await tokenService.clearTokens();
          return false;
        }
        await tokenService.saveAccessToken(newToken);
        return true;
      }
    }
    // verify token with backend

    final vaild = await authService.verifyAccessToken(access);
    if (!vaild) {
      final newToken = await authService.refreshAccessToken(refresh);
      if (newToken == null) {
        await tokenService.clearTokens();
        return false;
      }
      await tokenService.saveAccessToken(newToken);
      return true;
    }
    return true;
  }
}
