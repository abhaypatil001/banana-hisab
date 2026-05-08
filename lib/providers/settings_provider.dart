import 'package:flutter/material.dart';
import '../models/settings.dart';
import '../services/database_service.dart';

class SettingsProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  AppSettings _settings = AppSettings.defaults();

  AppSettings get settings => _settings;

  Future<void> loadSettings() async {
    final settingsMap = await _db.getAllSettings();
    if (settingsMap.isNotEmpty) {
      _settings = AppSettings.fromMap(settingsMap);
    } else {
      _settings = AppSettings.defaults();
      await saveSettings(_settings);
    }
    notifyListeners();
  }

  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    final map = settings.toMap();
    
    for (var entry in map.entries) {
      await _db.saveSetting(entry.key, entry.value);
    }
    
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    await saveSettings(AppSettings.defaults());
  }
}
