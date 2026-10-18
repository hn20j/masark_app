import 'package:masarak/services/account_repository.dart';

class FakeAccountRepository implements AccountRepository {
  final Map<String, Map<String, Object?>> accounts = {};

  @override
  Future<Map<String, Object?>?> getAccount(String uid) async {
    final account = accounts[uid];
    return account == null ? null : Map<String, Object?>.of(account);
  }

  @override
  Future<void> saveAccount(String uid, Map<String, Object?> account) async {
    accounts[uid] = {
      ...?accounts[uid],
      ...account,
      'uid': uid,
      'createdAt': accounts[uid]?['createdAt'] ?? DateTime.now(),
      'updatedAt': DateTime.now(),
    };
  }
}
