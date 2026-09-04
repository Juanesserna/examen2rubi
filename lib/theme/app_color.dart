import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryPink = Color(0xFFEE2B6C);

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFEE2E6E),
      Color(0xFFF17AA2),
    ],
  );
}