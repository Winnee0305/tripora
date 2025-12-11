enum NoteType {
  attraction,
  lodging,
  restaurant,
  transportation,
  note,
  attachment,
}

abstract class NoteBase {
  // User customizable fields
  String? userMessage;
  String? userPhotoPath;

  NoteBase({this.userMessage, this.userPhotoPath});
}
