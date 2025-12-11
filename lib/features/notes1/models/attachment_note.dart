import 'package:tripora/features/notes/models/note_base.dart';

class AttachmentNote extends NoteBase {
  final String pdfPath;

  AttachmentNote({
    required this.pdfPath,
    super.userMessage,
    super.userPhotoPath,
  });
}
