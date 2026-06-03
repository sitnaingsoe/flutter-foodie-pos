import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  final SharedPreferences prefs;

  TokenService(this.prefs);

  String? get accessToken => prefs.getString("accessToken");
  String? get refreshToken => prefs.getString("refreshToken");
  String? get expiryTime => prefs.getString("expireTime");

  Future<void> saveAccessToken(String token) async{
    await prefs.setString("accessToken", token);

  }
  Future<void> clearTokens() async{
    await prefs.clear();
  }
}
