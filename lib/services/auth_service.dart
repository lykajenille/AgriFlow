import '../models/user.dart';
import 'api_services.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<User?> login(String username, String password) async {
    try {
      var response = await _apiService.login(username, password);

      if (response['success'] == true && response['user'] != null) {
        return User.fromJson(response['user']);
      }

      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}