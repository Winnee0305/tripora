import 'package:flutter/material.dart';
import '../models/destination.dart';
import 'package:provider/provider.dart';

class ForYouViewModel extends ChangeNotifier {
  final PageController pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  int get currentPage => _currentPage;

  final List<Destination> destinations = [
    Destination(
      name: "Semporna",
      location: "Sabah, Malaysia",
      imagePath: "assets/images/exp_semporna.png",
      rating: 5.0,
    ),
    Destination(
      name: "Mount. Kinabalu",
      location: "Sabah, Malaysia",
      imagePath: "assets/images/exp_kinabalu.png",
      rating: 4.8,
    ),
    Destination(
      name: "Stadthuys",
      location: "Melaka, Malaysia",
      imagePath: "assets/images/exp_melaka.png",
      rating: 4.9,
    ),
    Destination(
      name: "Genting Highlands",
      location: "Pahang, Malaysia",
      imagePath: "assets/images/exp_genting.png",
      rating: 4.9,
    ),
    Destination(
      name: "KLCC",
      location: "Kuala Lumpur, Malaysia",
      imagePath: "assets/images/exp_kl.png",
      rating: 4.9,
    ),
  ];

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }
}
