// viewmodels/place_detail_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/poi.dart';
import '../models/review.dart';
import '../models/attraction.dart';
import '../models/operating_hours.dart';

class PoiPageViewmodel extends ChangeNotifier {
  late Poi place;
  List<Review> reviews = [];
  List<Attraction> nearbyAttractions = [];

  PoiPageViewmodel() {
    // Mock data for now, replace later with API
    place = Poi(
      name: "Stadthuys",
      location: "Melaka, Malaysia",
      description:
          "The Stadthuys (an old Dutch spelling, meaning city hall) is a historical structure situated in the heart of Malacca City, the administrative capital of the state of Malacca, Malaysia, in a place known as the Red Square. The Stadthuys is known for its red exterior and nearby red clocktower. It was built by the Dutch in 1650 as the office of the Dutch governor and deputy governor. It continued to be used as the Treasury, Post Office, Government Offices, and suites of apartments for the high officials after the takeover by the British.",
      image: "assets/images/exp_melaka.png",
      rating: 5.0,
      operatingHours: [
        OperatingHours(day: "Monday", open: "09:00", close: "17:30"),
        OperatingHours(day: "Tuesday", open: "09:00", close: "17:30"),
        OperatingHours(day: "Wednesday", open: "09:00", close: "17:30"),
        OperatingHours(day: "Thursday", open: "09:00", close: "17:30"),
        OperatingHours(day: "Friday", open: "09:00", close: "17:30"),
        OperatingHours(day: "Saturday", open: "09:00", close: "17:30"),
        OperatingHours(day: "Sunday", open: "09:00", close: "17:30"),
      ],
      address: "31, Jalan Laksamana, Banda Hilir, 75000 Melaka",
      tags: ["Historical", "Museum", "Architecture"],
    );

    reviews = [
      Review(
        userName: "LAWz93 (Pusheen Saviors)",
        userAvatar:
            "assets/images/exp_profile_picture.png", // placeholder avatar
        content:
            "A must visit if you're in Melaka. Stunning architecture and is a tourist hotspot for photography. Explore every building that used to be built from the Dutch's colonial. But do take umbrella and apply some sunscreen for UV protection. Do drink plenty of water. As current weather is so hot. 😄",
        rating: 5.0,
        date: DateTime(2025, 7, 2),
      ),
      Review(
        userName: "Syahmi Saiful",
        userAvatar: "assets/images/exp_profile_picture.png",
        content:
            "The Stadthuys is a beautiful historical landmark that showcases Melaka's rich heritage. The iconic red building and its surroundings are well-preserved, making it a must-visit for history enthusiasts and tourists alike. However, it would be great if more parking spaces could be provided nearby to make visits more convenient, especially during peak hours or weekends.",
        rating: 5.0,
        date: DateTime(2025, 6, 20),
      ),
    ];

    nearbyAttractions = [
      Attraction(
        name: "Jonker Street",
        imageUrl:
            "https://media.timeout.com/images/105875467/750/422/image.jpg",
        distance: "0.3 km away",
      ),
      Attraction(
        name: "Maritime Museum",
        imageUrl:
            "https://www.holidaygogogo.com/wp-content/uploads/2019/06/maritime-museum-melaka.jpg",
        distance: "0.5 km away",
      ),
    ];
  }
}
