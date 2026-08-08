import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufc_delivery_app/shared/theme/theme.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(AppTheme.light) {
    try {
      _loadTheme();
    } catch (e) {
      state = AppTheme.light;
    }
  }
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    state = isDarkMode ? AppTheme.dark : AppTheme.light;
  }

  Future<void> toggleTheme(bool isDarkMode) async {
    if (state == AppTheme.light) {
      state = AppTheme.dark;
    } else {
      state = AppTheme.light;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'isDarkMode', state == AppTheme.dark); // Save preference
  }
}
