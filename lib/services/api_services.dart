import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://agriflow.ginxproduction.com";

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body: {
        "username": username,
        "password": password,
      },
    );
    return jsonDecode(response.body);
  }

  // ── Dashboard Stats ──
  static Future<Map<String, dynamic>> getDashboardStats(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_dashboard_stats.php?user_id=$userId"),
    );
    return jsonDecode(response.body);
  }

  // ── Farms ──
  static Future<Map<String, dynamic>> getFarms(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_farms.php?user_id=$userId"),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addFarm({
    required int userId,
    required String farmName,
    String location = '',
    String size = '',
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_farm.php"),
      body: {
        "user_id": userId.toString(),
        "farm_name": farmName,
        "location": location,
        "size": size,
      },
    );
    return jsonDecode(response.body);
  }

  // ── Crops ──
  static Future<Map<String, dynamic>> getCrops(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_crops.php?user_id=$userId"),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addCrop({
    required int farmId,
    required String cropName,
    String plantingDate = '',
    String expectedHarvest = '',
    String status = 'Growing',
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_crop.php"),
      body: {
        "farm_id": farmId.toString(),
        "crop_name": cropName,
        "planting_date": plantingDate,
        "expected_harvest": expectedHarvest,
        "status": status,
      },
    );
    return jsonDecode(response.body);
  }

  // ── Reports ──
  static Future<List<dynamic>> getReports(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_reports.php?user_id=$userId"),
    );
    return jsonDecode(response.body);
  }

  // ── Expenses ──
  static Future<Map<String, dynamic>> addExpense({
    required int farmId,
    required String description,
    required String amount,
    String expenseDate = '',
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_expense.php"),
      body: {
        "farm_id": farmId.toString(),
        "description": description,
        "amount": amount,
        "expense_date": expenseDate,
      },
    );
    return jsonDecode(response.body);
  }

  // ══════════════════════════════════
  // Admin endpoints (all data, no user filter)
  // ══════════════════════════════════

  static Future<Map<String, dynamic>> getAdminStats() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin_stats.php"),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAdminUsers() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin_get_users.php"),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAdminFarms() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin_get_farms.php"),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAdminCrops() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin_get_crops.php"),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAdminReports() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin_get_reports.php"),
    );
    return jsonDecode(response.body);
  }
}