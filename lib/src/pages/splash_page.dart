import 'dart:async';
import 'package:SangKala/src/pages/dashboard.dart';
import 'package:SangKala/src/pages/login.dart';
import 'package:SangKala/src/utils/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Animasi fade in
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    _checkLoginStatus();

    // Navigasi setelah 3 detik
    // Timer(const Duration(seconds: 3), () {
    //   // TODO: cek apakah user sudah login
    //   // sementara ke login
    //   Navigator.pushReplacementNamed(context, "/login");
    // });
  }

  Future<void> _checkLoginStatus() async {
    final token = await StorageHelper.getToken();
    await Future.delayed(const Duration(seconds: 2)); // animasi splash

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Dashboard()),
      ); // atau route utama
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bisa ganti pakai logo PNG/SVG
              Icon(Icons.history_edu, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                "Sang Kala",
                style: AppFonts.heading.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Aplikasi Belajar Sejarah Pergerakan Nasional",
                style: AppFonts.body.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
