// models/review.dart
class Review {
  final String userName;
  final String userAvatar;
  final String content;
  final double rating;
  final DateTime date;

  Review({
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.rating,
    required this.date,
  });
}
