// lib/src/providers/material_provider.dart
import 'dart:convert';
import 'package:SangKala/src/models/materi.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MaterialProvider extends ChangeNotifier {
  final String baseUrl = "https://besangkala-production.up.railway.app/api/materials";
  List<Materi> _materiList = [];
  bool _isLoading = false;
  String? _error;

  List<Materi> get materiList => _materiList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- Cache Key ---
  final String cacheKey = "cached_materials";

  // Fetch all materials with caching
  Future<void> fetchMaterials({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Ambil cache dulu
      if (!forceRefresh && prefs.containsKey(cacheKey)) {
        final cached = prefs.getString(cacheKey);
        if (cached != null) {
          final List<dynamic> data = jsonDecode(cached) as List<dynamic>;
          _materiList = data
              .map((e) => Materi.fromJson(e as Map<String, dynamic>))
              .toList();
          _isLoading = false;
          notifyListeners();
          return; // stop dulu, pakai cache
        }
      }

      // 2. Fetch ke server
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
        _materiList = data
            .map((e) => Materi.fromJson(e as Map<String, dynamic>))
            .toList();

        // Simpan ke cache
        await prefs.setString(
          cacheKey,
          jsonEncode(_materiList.map((m) => m.toJson()).toList()),
        );
      } else {
        _error = 'Failed to load materials (status ${res.statusCode})';
      }
    } catch (e) {
      _error = 'Failed to load materials: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Materi? findMaterialById(String idOrNumeric) {
    try {
      return _materiList.firstWhere(
        (m) => m.id == idOrNumeric || m.numericId.toString() == idOrNumeric,
      );
    } catch (_) {
      return null;
    }
  }

  // Clear cache (opsional)
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cacheKey);
  }

  Materi? getNextMateri(Materi current) {
    final index = materiList.indexWhere((m) => m.id == current.id);
    if (index != -1 && index < materiList.length - 1) {
      return materiList[index + 1];
    }
    return null;
  }
}
