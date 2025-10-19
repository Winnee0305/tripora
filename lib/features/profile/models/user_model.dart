class UserModel {
  final String id;
  String displayName;
  String handle;
  String avatarUrl;
  int following;
  int followers;
  int likesComments;

  UserModel({
    required this.id,
    required this.displayName,
    required this.handle,
    required this.avatarUrl,
    required this.following,
    required this.followers,
    required this.likesComments,
  });
}
