import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  String baseUrl = "http://localhost/agriflow_api";

  Future login(String username,String password) async {

    var response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body:{
        "username":username,
        "password":password
      }
    );

    return jsonDecode(response.body);

  }

}