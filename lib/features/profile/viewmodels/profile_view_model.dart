import 'package:flutter/material.dart';
import 'package:tripora/features/profile/models/user_model.dart';
import 'package:tripora/features/search/models/travel_post.dart';

class ProfileViewModel extends ChangeNotifier {
  late UserModel user;
  // List<TripModel> sharedTrips = [];
  // List<TripModel> collects = [];
  List<Post> collects = [];

  ProfileViewModel() {
    _loadMock();
  }
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void selectTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void _loadMock() {
    user = UserModel(
      id: 'u1',
      displayName: 'Winnee',
      handle: '@winnee0305',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&q=80',
      following: 4,
      followers: 1,
      likesComments: 10,
    );

    // sharedTrips = [
    //   TripModel(
    //     id: 't1',
    //     title: 'Melaka 2 days family trip',
    //     location: 'Melacca, Malaysia',
    //     start: DateTime(2025, 8, 13),
    //     end: DateTime(2025, 8, 14),
    //     imageUrl:
    //         'https://images.unsplash.com/photo-1505765051770-204b8f6f8b8a?w=800&q=80',
    //     likes: 2,
    //   ),
    // ];

    collects = [
      Post(
        title: "Johor - Malaysia’s Southern Gem",
        location: "Johor, Malaysia",
        imageUrl: "assets/images/exp_johor.png",
        authorImageUrl: "assets/images/exp_profile_picture.png",
        likes: 58,
      ),
      Post(
        title: "Penang Guide",
        location: "Penang, Malaysia",
        imageUrl: "assets/images/exp_penang.png",
        authorImageUrl: "assets/images/exp_profile_picture.png",
        likes: 34,
      ),
    ];
  }

  // void toggleLikeOnShared(String tripId) {
  //   final t = sharedTrips.firstWhere((t) => t.id == tripId);
  //   // For mock: increment likes
  //   final updated = TripModel(
  //     id: t.id,
  //     title: t.title,
  //     location: t.location,
  //     start: t.start,
  //     end: t.end,
  //     imageUrl: t.imageUrl,
  //     likes: t.likes + 1,
  //   );
  //   final idx = sharedTrips.indexWhere((x) => x.id == tripId);
  //   sharedTrips[idx] = updated;
  //   notifyListeners();
  // }
}
