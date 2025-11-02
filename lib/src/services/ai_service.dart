import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://besangkala-production.up.railway.app/api"; // sesuaikan kalau deploy

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? "Tidak ada balasan.";
      } else {
        return "Error ${response.statusCode}: Gagal mendapatkan balasan.";
      }
    } catch (e) {
      return "Gagal koneksi ke server.";
    }
  }
}
