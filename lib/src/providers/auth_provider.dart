import 'dart:convert';
import 'package:SangKala/src/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/storage_helper.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _userId;
  User? _user;
  bool _isLoading = false;

  String? get token => _token;
  String? get userId => _userId;
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  final String baseUrl = "https://besangkala-production.up.railway.app";

  /// Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/users/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("🔍 Login response status: ${res.statusCode}");
      print("🔍 Login response body: ${res.body}");
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _token = data["token"];
        _userId = data["user"]["userId"];
        await StorageHelper.saveSession(_token!, _userId!);
        _user = User.fromJson(data["user"]);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e, s) {
      print("❌ Login parsing error: $e");
      print(s);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register
  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/users/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      if (res.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfile() async {
    final token = await StorageHelper.getToken();
    if (token == null) return;
    final res = await http.get(
      Uri.parse("$baseUrl/api/users/"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode == 200) {
      _user = User.fromJson(jsonDecode(res.body));
      _token = token;
      notifyListeners();
    }
  }

  /// Auto login (ambil session dari local storage)
  Future<void> tryAutoLogin() async {
    final token = await StorageHelper.getToken();
    final uid = await StorageHelper.getUserId();
    if (token != null && uid != null) {
      _token = token;
      _userId = uid;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    _token = null;
    _userId = null;
    await StorageHelper.clearSession();
    notifyListeners();
  }
}
