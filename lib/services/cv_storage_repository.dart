import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class CvStorageRepository {
  Future<String> upload({
    required String uid,
    required Uint8List bytes,
    required String fileName,
    required String contentType,
  });
}

class FirebaseCvStorageRepository implements CvStorageRepository {
  FirebaseCvStorageRepository() : _storage = FirebaseStorage.instance;

  final FirebaseStorage _storage;

  static CvStorageRepository createDefault() => Firebase.apps.isEmpty
      ? const UnavailableCvStorageRepository()
      : FirebaseCvStorageRepository();

  @override
  Future<String> upload({
    required String uid,
    required Uint8List bytes,
    required String fileName,
    required String contentType,
  }) async {
    final safeName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final path =
        'users/$uid/cv/${DateTime.now().millisecondsSinceEpoch}_$safeName';
    await _storage.ref(path).putData(
          bytes,
          SettableMetadata(
            contentType: contentType,
            customMetadata: {'originalFileName': fileName},
          ),
        );
    return path;
  }
}

class UnavailableCvStorageRepository implements CvStorageRepository {
  const UnavailableCvStorageRepository();

  @override
  Future<String> upload({
    required String uid,
    required Uint8List bytes,
    required String fileName,
    required String contentType,
  }) =>
      Future.error(
        StateError('Firebase Storage is not configured for this app.'),
      );
}
