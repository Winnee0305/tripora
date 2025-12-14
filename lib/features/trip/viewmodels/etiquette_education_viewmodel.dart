import 'package:flutter/material.dart';
import 'package:tripora/core/services/etiquette_education_service.dart';

class EtiquetteEducationViewModel extends ChangeNotifier {
  final EtiquetteEducationService _service = EtiquetteEducationService();

  String _currentTip = 'Loading travel etiquette tips...';
  int _currentTipIndex = 0;
  bool _isLoading = true;

  String get currentTip => _currentTip;
  int get currentTipIndex => _currentTipIndex;
  bool get isLoading => _isLoading;

  EtiquetteEducationViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.initialize(country: 'malaysia');
      _loadInitialTip();
    } catch (e) {
      print('Error initializing viewmodel: $e');
      _currentTip = 'Failed to load etiquette tips';
    }

    _isLoading = false;
    notifyListeners();
  }

  void _loadInitialTip() {
    _currentTip = _service.getRandomEtiquetteTip();
    notifyListeners();
  }

  /// Refresh to get a new random tip
  void refreshTip() {
    _currentTip = _service.getRandomEtiquetteTip();
    notifyListeners();
  }

  /// Get next tip
  void nextTip() {
    _currentTipIndex = (_currentTipIndex + 1) % _service.totalTips;
    _currentTip = _service.getEtiquetteTip(_currentTipIndex);
    notifyListeners();
  }

  /// Get previous tip
  void previousTip() {
    _currentTipIndex =
        (_currentTipIndex - 1 + _service.totalTips) % _service.totalTips;
    _currentTip = _service.getEtiquetteTip(_currentTipIndex);
    notifyListeners();
  }
}
