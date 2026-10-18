import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class AccountRepository {
  Future<Map<String, Object?>?> getAccount(String uid);

  Future<void> saveAccount(String uid, Map<String, Object?> account);
}

class FirestoreAccountRepository implements AccountRepository {
  final FirebaseFirestore _firestore;

  FirestoreAccountRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Map<String, Object?>?> getAccount(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .get(const GetOptions(source: Source.serverAndCache));
    final data = snapshot.data();
    return data == null ? null : Map<String, Object?>.from(data);
  }

  @override
  Future<void> saveAccount(String uid, Map<String, Object?> account) async {
    final reference = _firestore.collection('users').doc(uid);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(reference);
      transaction.set(
        reference,
        {
          ...account,
          'uid': uid,
          'createdAt':
              snapshot.data()?['createdAt'] ?? FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
    });
  }
}
