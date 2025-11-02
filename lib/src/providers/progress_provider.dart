import 'dart:convert';
import 'package:SangKala/src/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/progress.model.dart';

class ProgressProvider with ChangeNotifier {
  final String baseUrl;
  String? _token;
  User? user;

  ProgressProvider({required this.baseUrl, String? token}) : _token = token;

  List<Progress> _progressList = [];
  Progress? _activeProgress;
  bool _isLoading = false;

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  String? get token => _token;
  int get initialIndex {
    return _activeProgress?.currentIndex ?? 0;
  }

  String get getUsername {
    if (user != null && _activeProgress != null) {
      if (user!.id == _activeProgress!.userId) {
        return user!.username;
      }
    }
    return "Guest";
  }

  int get completedMaterialCount => _progressList.where((p) => p.done).length;

  int get totalMaterialCount => progressList.length;

  int get progressPercentage {
    if (totalMaterialCount == 0) return 0;
    return ((completedMaterialCount / totalMaterialCount) * 100).round();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  List<Progress> get progressList => _progressList;
  Progress? get activeProgress => _activeProgress;
  bool get isLoading => _isLoading;

  void setActiveProgress(Progress? progress) {
    _activeProgress = progress;
    notifyListeners();
  }

  void setProgress(Progress? progress) {
    _progressList = [progress!];
    _activeProgress = progress;
    notifyListeners();
  }

  /// Helper untuk request agar tidak duplikatif
  Future<void> _doRequest(
    Future<http.Response> Function() request,
    void Function(dynamic data) onSuccess,
  ) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final res = await request();
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        onSuccess(data);
      } else {
        throw Exception("Request failed: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("ProgressProvider error: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // cukup sekali di sini
    }
  }

  /// Fetch semua progress user
  Future<void> fetchProgress() async {
    return _doRequest(
      () => http.get(
        Uri.parse("$baseUrl/"),
        headers: {"Authorization": "Bearer $token"},
      ),
      (data) {
        debugPrint(">>> fetchProgress raw: $data");

        if (data is List) {
          _progressList = data.map((p) => Progress.fromJson(p)).toList();
          if (_progressList.isNotEmpty) {
            _activeProgress = _progressList.firstWhere(
              (p) => p.done == false,
              orElse: () => _progressList.last,
            );
          }
        } else {
          debugPrint(">>> Unexpected response: $data");
        }

        debugPrint(">>> Active progress: ${_activeProgress?.toJson()}");
      },
    );
  }

  /// Fetch progress spesifik
  Future<void> fetchProgressByMaterial(String materialId) async {
    return _doRequest(
      () => http.get(
        Uri.parse("$baseUrl/$materialId"),
        headers: {"Authorization": "Bearer $token"},
      ),
      (data) => _activeProgress = Progress.fromJson(data),
    );
  }

  /// Buat progress baru
  Future<void> addProgress(String materialId) async {
    return _doRequest(
      () => http.post(
        Uri.parse("$baseUrl/add"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"materialId": materialId}),
      ),
      (data) {
        final newProgress = Progress.fromJson(data);
        _progressList.add(newProgress);
        _activeProgress = newProgress;
      },
    );
  }

  /// Simpan state halaman terakhir
  Future<void> saveState(String progressId, int currentIndex) async {
    return _doRequest(
      () => http.patch(
        Uri.parse("$baseUrl/state"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "progressId": progressId,
          "currentIndex": currentIndex,
        }),
      ),
      (data) {
        final updated = Progress.fromJson(data);
        _activeProgress = updated;

        final idx = _progressList.indexWhere((p) => p.id == updated.id);
        if (idx != -1) {
          _progressList[idx] = updated;
        } else {
          _progressList.add(updated);
        }
        notifyListeners();
      },
    );
  }

  /// Tandai materi selesai
  Future<void> markAsDone(String progressId) async {
    return _doRequest(
      () => http.patch(
        Uri.parse("$baseUrl/done"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"progressId": progressId}),
      ),
      (data) {
        final updated = Progress.fromJson(data);
        _activeProgress = updated;

        final idx = _progressList.indexWhere((p) => p.id == updated.id);
        if (idx != -1) {
          _progressList[idx] = updated;
        } else {
          _progressList.add(updated);
        }
        notifyListeners();
      },
    );
  }

  Future<void> updateCurrentPage(String progressId, int currentIndex) async {
    return _doRequest(
      () => http.patch(
        Uri.parse("$baseUrl/page"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "progressId": progressId,
          "currentIndex": currentIndex,
        }),
      ),
      (data) {
        _activeProgress = Progress.fromJson(data);
        // kalau progressList ada, update juga yang sesuai
        final idx = _progressList.indexWhere((p) => p.id == progressId);
        if (idx != -1) {
          _progressList[idx] = _activeProgress!;
        }
      },
    );
  }

  /// Submit quiz
  Future<void> submitQuiz(
    String progressId,
    String quizId,
    List<Map<String, dynamic>> answers,
  ) async {
    final payload = {
      "progressId": progressId,
      "quizId": quizId,
      "answers": answers,
    };
    debugPrint(">>> SubmitQuiz payload: ${jsonEncode(payload)}");
    return _doRequest(
      () => http.post(
        Uri.parse("$baseUrl/quiz/submit"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      ),
      (data) {
        debugPrint(">>> SubmitQuiz response: $data");

        if (data["progress"] != null) {
          _activeProgress = Progress.fromJson(data["progress"]);
        }
      },
    );
  }

  /// Lanjut ke materi berikutnya
  Future<void> goToNextMaterial(String progressId) async {
    return _doRequest(
      () => http.patch(
        Uri.parse("$baseUrl/next"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"progressId": progressId}),
      ),
      (data) {
        if (data["progress"] != null) {
          final newProgress = Progress.fromJson(data["progress"]);
          _activeProgress = newProgress;

          final idx = _progressList.indexWhere((p) => p.id == newProgress.id);
          if (idx != -1) {
            _progressList[idx] = newProgress;
          } else {
            _progressList.add(newProgress);
          }
          notifyListeners();
        } else {
          debugPrint("No progress returned, fetching full list...");
          fetchProgress();
        }
      },
    );
  }

  void setActiveProgressFromJson(Map<String, dynamic> json) {
    _activeProgress = Progress.fromJson(json);
    notifyListeners();
  }

  /// Cari progress untuk materi tertentu (cocokkan dengan materi.id yang berupa number/string)
  Progress? progressForMaterial(String materialId) {
    try {
      return _progressList.firstWhere(
        (p) => p.material.id.toString() == materialId.toString(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Apakah materi ini adalah active material (sedang dipelajari)
  bool isActiveMaterial(String materialId) {
    return _activeProgress != null &&
        _activeProgress!.material.id.toString() == materialId.toString();
  }

  /// Apakah materi sudah completed (kriteria: done/last page AND quizTaken == true)
  bool isMaterialCompleted(String materialId) {
    final p = progressForMaterial(materialId);
    if (p == null) return false;
    final total = p.material.content.length;
    final reachedEnd = p.currentIndex >= (total > 0 ? total - 1 : 0);
    return reachedEnd && p.quizTaken == true;
  }

  /// Progress fraction (0..1) dari materi (fallback 0.0)
  double materialProgressFraction(String materialId) {
    final p = progressForMaterial(materialId);
    if (p == null) return 0.0;
    final total = p.material.content.length;
    if (total <= 0) return 0.0;
    final frac = (p.currentIndex + 1) / total;
    return frac.clamp(0.0, 1.0);
  }
}
