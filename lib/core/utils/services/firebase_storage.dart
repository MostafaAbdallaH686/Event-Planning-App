import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class FirebaseImageStorage {
  final FirebaseStorage storage;
  FirebaseImageStorage(this.storage);

  Future<String> uploadEventImage({
    required File file,
    required String uid,
  }) async {
    final ext = p.extension(file.path); // .jpg, etc.
    final name = '${uid}_${DateTime.now().millisecondsSinceEpoch}$ext';
    final ref = storage.ref().child('events/$name');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
