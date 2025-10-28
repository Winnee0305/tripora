import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UploadTask> uploadFile(String path, File file) async {
    final ref = _storage.ref(path);
    return ref.putFile(file);
  }

  Future<String> getDownloadUrl(String path) async {
    final ref = _storage.ref(path);
    return ref.getDownloadURL();
  }

  Future<void> deleteFile(String path) async {
    final ref = _storage.ref(path);
    await ref.delete();
  }
}
