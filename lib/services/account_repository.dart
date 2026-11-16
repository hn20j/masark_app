import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AccountRepository {
  Future<Map<String, Object?>?> getAccount(String uid);

  Future<void> saveAccount(String uid, Map<String, Object?> account);
}

class FirebaseAccountRepository implements AccountRepository {
  FirebaseAccountRepository() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static AccountRepository createDefault() => Firebase.apps.isEmpty
      ? const UnavailableAccountRepository()
      : FirebaseAccountRepository();

  @override
  Future<Map<String, Object?>?> getAccount(String uid) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      final data = snapshot.data();
      if (data == null) return null;
      return data.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate().toIso8601String());
        }
        return MapEntry(key, value);
      });
    } on FirebaseException catch (error) {
      throw StateError(
        'Could not load the account profile: ${error.message ?? error.code}',
      );
    }
  }

  @override
  Future<void> saveAccount(String uid, Map<String, Object?> account) async {
    try {
      await _firestore.collection('users').doc(uid).set(account);
    } on FirebaseException catch (error) {
      throw StateError(
        'Could not save the account profile: ${error.message ?? error.code}',
      );
    }
  }
}

class UnavailableAccountRepository implements AccountRepository {
  const UnavailableAccountRepository();

  StateError _unavailable() =>
      StateError('Firebase is not initialized. Check the Firebase app setup.');

  @override
  Future<Map<String, Object?>?> getAccount(String uid) =>
      Future.error(_unavailable());

  @override
  Future<void> saveAccount(String uid, Map<String, Object?> account) =>
      Future.error(_unavailable());
}

class LocalAccountRepository implements AccountRepository {
  static const _keyPrefix = 'local_account_';

  @override
  Future<Map<String, Object?>?> getAccount(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString('$_keyPrefix$uid');
    if (value == null) return null;
    final decoded = jsonDecode(value);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Stored account data is not an object.');
    }
    return Map<String, Object?>.from(decoded);
  }

  @override
  Future<void> saveAccount(String uid, Map<String, Object?> account) async {
    final preferences = await SharedPreferences.getInstance();
    final stored = await preferences.setString(
      '$_keyPrefix$uid',
      jsonEncode(account),
    );
    if (!stored) {
      throw StateError('Could not save the account profile on this device.');
    }
  }
}
