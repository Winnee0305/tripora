import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tripora/core/services/place_auto_complete_service.dart';

class SearchSuggestionViewModel extends ChangeNotifier {
  // Replace with your actual API key and token management
  final AutocompleteService autocompleteService = AutocompleteService();

  List<dynamic> _suggestions = [];
  List<dynamic> get suggestions => _suggestions;

  Timer? _debounce;

  void onSearchChanged(String input) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      _suggestions = await autocompleteService.fetchSuggestions(input);
      notifyListeners();
    });
  }

  void clearSuggestions() {
    _suggestions.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
