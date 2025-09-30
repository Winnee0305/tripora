import 'package:flutter/foundation.dart';
import 'package:tripora/features/home/models/travel_post.dart';

class TravelersVoiceViewmodel extends ChangeNotifier {
  final List<TravelPost> _guides = [
    TravelPost(
      title: "Johor - Malaysia’s Southern Gem",
      location: "Johor, Malaysia",
      imageUrl: "assets/images/exp_johor.png",
      authorImageUrl: "assets/images/exp_profile_picture.png",
      likes: 58,
    ),
    TravelPost(
      title: "Penang Guide",
      location: "Penang, Malaysia",
      imageUrl: "assets/images/exp_penang.png",
      authorImageUrl: "assets/images/exp_profile_picture.png",
      likes: 34,
    ),
    TravelPost(
      title: "3 Days in Kuala Lumpur, Malaysia",
      location: "Kuala Lumpur, Malaysia",
      imageUrl: "assets/images/exp_kl2.png",
      authorImageUrl: "assets/images/exp_profile_picture.png",
      likes: 29,
    ),
    TravelPost(
      title: "Top Things to do in Malaysia",
      location: "Malaysia",
      imageUrl: "assets/images/exp_msia.png",
      authorImageUrl: "assets/images/exp_profile_picture.png",
      likes: 74,
    ),
  ];

  List<TravelPost> get guides => _guides;
}
