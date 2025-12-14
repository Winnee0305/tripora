import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

/// Service to provide travel etiquette tips from JSON files
class EtiquetteEducationService {
  static final EtiquetteEducationService _instance =
      EtiquetteEducationService._internal();

  factory EtiquetteEducationService() {
    return _instance;
  }

  EtiquetteEducationService._internal();

  List<String> _etiquetteTips = [];
  bool _isLoaded = false;

  /// Initialize the service by loading etiquette tips from JSON files
  Future<void> initialize({String country = 'malaysia'}) async {
    if (_isLoaded) return;

    try {
      _etiquetteTips = [];

      // Load all etiquette JSON files
      final categories = [
        'basic_etiquette',
        'dos',
        'donts',
        'eating',
        'gift_giving',
        'greetings',
        'visiting',
      ];

      for (final category in categories) {
        try {
          final jsonString = await rootBundle.loadString(
            'assets/data/culture/$country/$category.json',
          );
          final jsonData = jsonDecode(jsonString);

          if (jsonData is Map && jsonData['guidelines'] is List) {
            final guidelines = jsonData['guidelines'] as List<dynamic>;
            for (final guideline in guidelines) {
              if (guideline is Map && guideline['text'] is String) {
                _etiquetteTips.add(guideline['text']);
              }
            }
          }
        } catch (e) {
          print('Error loading $category.json: $e');
          // Continue with other files if one fails
        }
      }

      _isLoaded = true;
      print('Loaded ${_etiquetteTips.length} etiquette tips');
    } catch (e) {
      print('Error initializing EtiquetteEducationService: $e');
      _isLoaded =
          true; // Mark as loaded even if error to prevent infinite retries
    }
  }

  /// Get a random etiquette tip
  String getRandomEtiquetteTip() {
    if (_etiquetteTips.isEmpty) {
      return 'Loading etiquette tips...';
    }
    final random = Random();
    return _etiquetteTips[random.nextInt(_etiquetteTips.length)];
  }

  /// Get a specific etiquette tip by index
  String getEtiquetteTip(int index) {
    if (_etiquetteTips.isEmpty) {
      return 'Loading etiquette tips...';
    }
    if (index < 0 || index >= _etiquetteTips.length) {
      return getRandomEtiquetteTip();
    }
    return _etiquetteTips[index];
  }

  /// Get all etiquette tips
  List<String> getAllEtiquetteTips() {
    return List.from(_etiquetteTips);
  }

  /// Get total number of tips
  int get totalTips => _etiquetteTips.length;

  /// Check if tips are loaded
  bool get isLoaded => _isLoaded;
}
