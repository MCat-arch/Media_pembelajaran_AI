import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle heading = GoogleFonts.merriweather(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle subHeading = GoogleFonts.merriweather(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.black87,
  );

  static TextStyle bodySecondary = GoogleFonts.poppins(
    fontSize: 12,
    color: Colors.black54,
  );
}
