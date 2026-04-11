import '../models/user.dart';
import 'api_services.dart';

class AuthService {
  Future<User?> login(String username, String password) async {
    try {
      var response = await ApiService.login(username, password);

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