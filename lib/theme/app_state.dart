import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/account_repository.dart';
import '../services/push_notification_service.dart';

/// App-wide state shared via Provider.
class AppState extends ChangeNotifier {
  final FirebaseAuth _auth;
  final AccountRepository _accountRepository;
  final Completer<void> _authReadyCompleter = Completer<void>();
  late final StreamSubscription<User?> _authSubscription;
  late final StreamSubscription<String> _pushTokenSubscription;
  String? _phoneVerificationId;
  ConfirmationResult? _webPhoneConfirmation;

  AppUser? currentUser;
  String? pushToken;
  bool agentAutoApplyEnabled = true;
  Locale locale = const Locale('ar');
  bool _localeChanged = false;

  AppState({
    FirebaseAuth? auth,
    AccountRepository? accountRepository,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _accountRepository =
            accountRepository ?? FirestoreAccountRepository() {
    _authSubscription = _auth.authStateChanges().listen((user) {
      _setCurrentUser(user);
      if (!_authReadyCompleter.isCompleted) _authReadyCompleter.complete();
    });
    _pushTokenSubscription =
        PushNotificationService.instance.tokenChanges.listen((token) {
      pushToken = token;
      notifyListeners();
    });
  }

  Future<void> get authReady => _authReadyCompleter.future;

  Future<String?> enablePushNotifications() async {
    final token =
        await PushNotificationService.instance.requestPermissionAndGetToken();
    pushToken = token;
    notifyListeners();
    return token;
  }

  Future<void> loadLocale() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final languageCode = preferences.getString('languageCode');
      if (!_localeChanged && (languageCode == 'ar' || languageCode == 'en')) {
        locale = Locale(languageCode!);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> setLocale(Locale value) async {
    if (value.languageCode != 'ar' && value.languageCode != 'en') return;
    _localeChanged = true;
    if (locale != value) {
      locale = value;
      notifyListeners();
    }
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('languageCode', value.languageCode);
    } catch (_) {}
  }

  Future<void> signIn({
    required String email,
    required String password,
    required String homeCountry,
    String accountType = 'employee',
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _setCurrentUser(credential.user, homeCountry: homeCountry);
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase Authentication returned no signed-in user.');
    }
    await _restoreProfileDetails(user.uid, fallbackAccountType: accountType);
    if (currentUser?.accountType != accountType) {
      throw FirebaseAuthException(
        code: 'account-type-mismatch',
        message: 'This account uses a different account type.',
      );
    }
  }

  Future<void> sendPhoneVerificationCode({
    required String phoneNumber,
    required VoidCallback onCodeSent,
    required ValueChanged<FirebaseAuthException> onVerificationFailed,
    required ValueChanged<PhoneAuthCredential> onVerificationCompleted,
  }) async {
    if (kIsWeb) {
      _webPhoneConfirmation = await _auth.signInWithPhoneNumber(phoneNumber);
      onCodeSent();
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: (verificationId, _) {
        _phoneVerificationId = verificationId;
        onCodeSent();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _phoneVerificationId = verificationId;
      },
    );
  }

  Future<UserCredential> confirmPhoneCode(String smsCode) async {
    late final UserCredential credential;
    if (kIsWeb) {
      final confirmation = _webPhoneConfirmation;
      if (confirmation == null) {
        throw FirebaseAuthException(
          code: 'missing-verification-id',
          message: 'Request a verification code first.',
        );
      }
      credential = await confirmation.confirm(smsCode);
      _webPhoneConfirmation = null;
    } else {
      final verificationId = _phoneVerificationId;
      if (verificationId == null) {
        throw FirebaseAuthException(
          code: 'missing-verification-id',
          message: 'Request a verification code first.',
        );
      }
      credential = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        ),
      );
      _phoneVerificationId = null;
    }
    _setCurrentUser(credential.user);
    return credential;
  }

  Future<UserCredential> signInWithPhoneCredential(
    PhoneAuthCredential phoneCredential,
  ) async {
    final credential = await _auth.signInWithCredential(phoneCredential);
    _setCurrentUser(credential.user);
    return credential;
  }

  Future<void> completePhoneSignUpProfile({
    required String name,
    required DateTime birthdate,
    required String governorate,
    required String governorateRegion,
    required String academicAchievement,
    required List<String> workPreferences,
    required String workLocation,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Phone verification is required before profile creation.',
      );
    }
    await user.updateDisplayName(name);
    _setCurrentUser(user, homeCountry: 'Iraq', fallbackName: name);
    currentUser!.accountType = 'employee';
    await updateProfileDetails(
      birthdate: birthdate,
      governorate: governorate,
      governorateRegion: governorateRegion,
      academicAchievement: academicAchievement,
      workPreferences: workPreferences,
      workLocation: workLocation,
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String homeCountry,
    required DateTime birthdate,
    required String governorate,
    required String governorateRegion,
    required String academicAchievement,
    required List<String> workPreferences,
    required String workLocation,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase Authentication returned no new user.');
    }
    await user.updateDisplayName(name);
    _setCurrentUser(user, homeCountry: homeCountry, fallbackName: name);
    currentUser!.accountType = 'employee';
    await updateProfileDetails(
      birthdate: birthdate,
      governorate: governorate,
      governorateRegion: governorateRegion,
      academicAchievement: academicAchievement,
      workPreferences: workPreferences,
      workLocation: workLocation,
    );
  }

  Future<void> signUpCompany({
    required String companyName,
    required String email,
    required String password,
    required String phone,
    required String responsiblePerson,
    required String governorate,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase Authentication returned no new user.');
    }
    await user.updateDisplayName(companyName);
    _setCurrentUser(
      user,
      homeCountry: 'Iraq',
      fallbackName: companyName,
    );
    final company = currentUser!;
    company
      ..accountType = 'company'
      ..phone = phone
      ..responsiblePerson = responsiblePerson
      ..companyContactEmail = email
      ..governorate = governorate;
    await _saveAccountProfile(company);
  }

  Future<void> sendPasswordResetEmail({required String email}) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  void _setCurrentUser(
    User? user, {
    String homeCountry = 'Iraq',
    String? fallbackName,
  }) {
    if (user == null) {
      currentUser = null;
      pushToken = null;
    } else {
      final previousUser = currentUser;
      final email = user.email ?? '';
      final displayName = user.displayName?.trim();
      final sameUser = previousUser?.uid == user.uid;
      if (!sameUser) pushToken = null;
      currentUser = AppUser(
        uid: user.uid,
        name: displayName?.isNotEmpty == true
            ? displayName!
            : fallbackName ?? email.split('@').first,
        email: email,
        accountType:
            sameUser ? previousUser!.accountType : 'employee',
        homeCountry: sameUser ? previousUser!.homeCountry : homeCountry,
        phone: sameUser ? previousUser!.phone : user.phoneNumber,
        responsiblePerson:
            sameUser ? previousUser!.responsiblePerson : null,
        companyContactEmail:
            sameUser ? previousUser!.companyContactEmail : null,
        cvFileName: sameUser ? previousUser!.cvFileName : null,
        cvFilePath: sameUser ? previousUser!.cvFilePath : null,
        profileCompletion: sameUser ? previousUser!.profileCompletion : 0.2,
        birthdate: sameUser ? previousUser!.birthdate : null,
        governorate: sameUser ? previousUser!.governorate : null,
        governorateRegion: sameUser ? previousUser!.governorateRegion : null,
        academicAchievement:
            sameUser ? previousUser!.academicAchievement : null,
        workPreferences: sameUser ? List.of(previousUser!.workPreferences) : [],
        workLocation: sameUser ? previousUser!.workLocation : null,
        skills: sameUser ? List.of(previousUser!.skills) : [],
        careerCategory: sameUser ? previousUser!.careerCategory : null,
        universityMajor: sameUser ? previousUser!.universityMajor : null,
        yearsExperience: sameUser ? previousUser!.yearsExperience : null,
        preferredCountry: sameUser ? previousUser!.preferredCountry : 'Iraq',
        remoteOk: sameUser ? previousUser!.remoteOk : true,
      );
    }
    notifyListeners();
  }

  void updateAccount({required String name, required String email}) {
    if (currentUser == null) return;
    currentUser!
      ..name = name
      ..email = email;
    notifyListeners();
  }

  Future<void> updateProfileDetails({
    required DateTime birthdate,
    required String governorate,
    required String governorateRegion,
    required String academicAchievement,
    required List<String> workPreferences,
    required String workLocation,
  }) async {
    final user = currentUser;
    if (user == null) return;
    user
      ..birthdate = birthdate
      ..governorate = governorate
      ..governorateRegion = governorateRegion
      ..academicAchievement = academicAchievement
      ..workPreferences = List.of(workPreferences)
      ..workLocation = workLocation;
    await _saveAccountProfile(user);
    notifyListeners();
  }

  Future<void> saveApplicationPreferences({
    required List<String> targetRoles,
    required List<String> skills,
    required String? careerCategory,
    required String? universityMajor,
    required String? yearsExperience,
    required bool remoteOk,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required to save preferences.');
    }
    if (user.accountType != 'employee') {
      throw StateError('Only employee accounts can save job preferences.');
    }
    user
      ..workPreferences = List.of(targetRoles)
      ..skills = List.of(skills)
      ..careerCategory = careerCategory
      ..universityMajor = universityMajor
      ..yearsExperience = yearsExperience
      ..preferredCountry = 'Iraq'
      ..remoteOk = remoteOk;
    await _saveAccountProfile(user);
    notifyListeners();
  }

  Map<String, Object?> _accountData(AppUser user) => {
        'name': user.name,
        'email': user.email,
        'accountType': user.accountType,
        'homeCountry': user.homeCountry,
        'phone': user.phone,
        'responsiblePerson': user.responsiblePerson,
        'companyContactEmail': user.companyContactEmail,
        'birthdate': user.birthdate,
        'governorate': user.governorate,
        'governorateRegion': user.governorateRegion,
        'academicAchievement': user.academicAchievement,
        'workPreferences': user.workPreferences,
        'workLocation': user.workLocation,
        'skills': user.skills,
        'careerCategory': user.careerCategory,
        'universityMajor': user.universityMajor,
        'yearsExperience': user.yearsExperience,
        'preferredCountry': user.preferredCountry,
        'remoteOk': user.remoteOk,
        'cvFileName': user.cvFileName,
        'profileCompletion': user.profileCompletion,
      };

  Future<void> _saveAccountProfile(AppUser user) {
    return _accountRepository.saveAccount(user.uid, _accountData(user));
  }

  Future<void> updateCompanyProfile({
    required String companyName,
    required String contactEmail,
    required String phone,
    required String responsiblePerson,
    required String governorate,
  }) async {
    final user = currentUser;
    if (user == null || user.accountType != 'company') {
      throw StateError('A signed-in company account is required.');
    }
    final oldValues = (
      user.name,
      user.companyContactEmail,
      user.phone,
      user.responsiblePerson,
      user.governorate,
    );
    user
      ..name = companyName
      ..companyContactEmail = contactEmail
      ..phone = phone
      ..responsiblePerson = responsiblePerson
      ..governorate = governorate;
    try {
      await _saveAccountProfile(user);
    } catch (_) {
      user
        ..name = oldValues.$1
        ..companyContactEmail = oldValues.$2
        ..phone = oldValues.$3
        ..responsiblePerson = oldValues.$4
        ..governorate = oldValues.$5;
      rethrow;
    }
    notifyListeners();
  }

  Future<bool> restoreProfileDetails({
    String fallbackAccountType = 'employee',
    bool createIfMissing = true,
  }) async {
    final user = currentUser;
    if (user != null) {
      return _restoreProfileDetails(
        user.uid,
        fallbackAccountType: fallbackAccountType,
        createIfMissing: createIfMissing,
      );
    }
    return false;
  }

  Future<bool> _restoreProfileDetails(
    String uid, {
    required String fallbackAccountType,
    bool createIfMissing = true,
  }) async {
    final profile = await _accountRepository.getAccount(uid);
    if (currentUser?.uid != uid) return false;
    if (profile == null) {
      if (!createIfMissing) return false;
      final user = currentUser!;
      user.accountType = fallbackAccountType;
      await _saveAccountProfile(user);
      notifyListeners();
      return true;
    }

    final current = currentUser!;
    final birthdate = profile['birthdate'];
    current
      ..name = profile['name'] as String? ?? current.name
      ..email = profile['email'] as String? ?? current.email
      ..accountType = profile['accountType'] == 'company'
          ? 'company'
          : profile['accountType'] == 'employee'
              ? 'employee'
              : fallbackAccountType
      ..homeCountry = profile['homeCountry'] as String? ?? current.homeCountry
      ..phone = profile['phone'] as String?
      ..responsiblePerson = profile['responsiblePerson'] as String?
      ..companyContactEmail = profile['companyContactEmail'] as String?
      ..birthdate = birthdate is Timestamp
          ? birthdate.toDate()
          : birthdate is DateTime
              ? birthdate
              : null
      ..governorate = profile['governorate'] as String?
      ..governorateRegion = profile['governorateRegion'] as String?
      ..academicAchievement = profile['academicAchievement'] as String?
      ..workPreferences = _stringList(profile['workPreferences'])
      ..workLocation = profile['workLocation'] as String?
      ..skills = _stringList(profile['skills'])
      ..careerCategory = profile['careerCategory'] as String?
      ..universityMajor = profile['universityMajor'] as String?
      ..yearsExperience = profile['yearsExperience'] as String?
      ..preferredCountry = profile['preferredCountry'] as String? ?? 'Iraq'
      ..remoteOk = profile['remoteOk'] as bool? ?? true
      ..cvFileName = profile['cvFileName'] as String?
      ..profileCompletion =
          (profile['profileCompletion'] as num?)?.toDouble() ?? 0.2;
    notifyListeners();
    return true;
  }

  List<String> _stringList(Object? value) =>
      (value as List<dynamic>? ?? []).whereType<String>().toList();

  Future<void> attachCv(String fileName, String path) async {
    final user = currentUser;
    if (user == null) return;
    user
      ..cvFileName = fileName
      ..cvFilePath = path
      ..profileCompletion = 0.65;
    await _saveAccountProfile(user);
    notifyListeners();
  }

  Future<void> completeProfile() async {
    final user = currentUser;
    if (user == null) return;
    user.profileCompletion = 1.0;
    await _saveAccountProfile(user);
    notifyListeners();
  }

  void toggleAgentAutoApply(bool value) {
    agentAutoApplyEnabled = value;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_authSubscription.cancel());
    unawaited(_pushTokenSubscription.cancel());
    super.dispose();
  }
}
