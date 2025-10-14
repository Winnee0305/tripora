import 'note_base.dart';

class AttachmentNote extends NoteBase {
  final String fileName;
  final String filePath;
  final String fileType;

  const AttachmentNote({
    required super.id,
    required super.title,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    super.imageUrl,
  }) : super(type: NoteType.attachment);
}
