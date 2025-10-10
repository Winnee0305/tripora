import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripViewModel extends ChangeNotifier {
  final PageController pageController = PageController(viewportFraction: 1);
  int currentPage = 0;

  late Trip trip;

  TripViewModel() {
    // mock trip data
    trip = Trip(
      id: 't1',
      name: 'Melaka 2 days family trip',
      image: 'assets/images/exp_melaka_trip.png',
      destination: 'Melacca',
      country: 'Malaysia',
      start: DateTime(2025, 8, 13),
      end: DateTime(2025, 8, 14),
      notesCount: 5,
      expense: 303.00,
      itineraryCount: 9,
      packingCount: 7,
      attachments: 0,
      tags: ['family', 'heritage', 'food'],
    );
  }

  void onPageChanged(int idx) {
    currentPage = idx;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
