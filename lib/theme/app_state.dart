import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../services/account_repository.dart';
import '../services/auth_repository.dart';
import '../services/cv_storage_repository.dart';
import '../services/marketplace_repository.dart';

/// App-wide state shared via Provider.
class AppState extends ChangeNotifier {
  final AccountRepository _accountRepository;
  final AuthRepository _authRepository;
  final MarketplaceRepository _marketplaceRepository;
  final CvStorageRepository _cvStorageRepository;
  StreamSubscription<AuthIdentity?>? _authSubscription;
  StreamSubscription<List<Job>>? _jobsSubscription;
  Future<void>? _initializeFuture;
  int _jobWatchVersion = 0;
  bool _localeChanged = false;
  bool _themeModeChanged = false;

  AppUser? currentUser;
  List<Job> jobs = [];
  List<Job> companyJobs = [];
  List<Application> applications = [];
  List<Application> companyApplications = [];
  List<AppNotification> notifications = [];
  bool authInitializing = true;
  bool jobsLoading = false;
  bool applicationsLoading = false;
  bool notificationsLoading = false;
  String? authError;
  String? jobsError;
  String? applicationsError;
  String? notificationsError;
  Locale locale = const Locale('ar');
  ThemeMode themeMode = ThemeMode.dark;

  AppState({
    AccountRepository? accountRepository,
    AuthRepository? authRepository,
    MarketplaceRepository? marketplaceRepository,
    CvStorageRepository? cvStorageRepository,
  })  : _accountRepository =
            accountRepository ?? FirebaseAccountRepository.createDefault(),
        _authRepository =
            authRepository ?? FirebaseAuthRepository.createDefault(),
        _marketplaceRepository = marketplaceRepository ??
            FirebaseMarketplaceRepository.createDefault(),
        _cvStorageRepository =
            cvStorageRepository ?? FirebaseCvStorageRepository.createDefault();

  Future<void> initialize() => _initializeFuture ??= _initialize();

  Future<void> _initialize() async {
    await loadLocale();
    await loadThemeMode();
    _authSubscription = _authRepository.authStateChanges.listen(
      (identity) => unawaited(_handleAuthStateChanged(identity)),
      onError: (Object error) {
        authError = _errorMessage(error);
        authInitializing = false;
        notifyListeners();
      },
    );
    try {
      await _handleAuthStateChanged(_authRepository.currentUser);
    } finally {
      authInitializing = false;
      notifyListeners();
    }
  }

  Future<void> _handleAuthStateChanged(AuthIdentity? identity) async {
    final watchVersion = ++_jobWatchVersion;
    final jobsSubscription = _jobsSubscription;
    _jobsSubscription = null;
    await jobsSubscription?.cancel();
    if (watchVersion != _jobWatchVersion) return;

    if (identity == null) {
      currentUser = null;
      jobs = [];
      companyJobs = [];
      applications = [];
      companyApplications = [];
      notifications = [];
      notifyListeners();
      return;
    }

    currentUser = AppUser(
      uid: identity.uid,
      name: identity.displayName ?? identity.email?.split('@').first ?? '',
      email: identity.email ?? '',
      homeCountry: 'Iraq',
    );
    authError = null;
    notifyListeners();
    try {
      await _restoreProfileDetails(
        identity.uid,
        fallbackAccountType: 'employee',
        createIfMissing: false,
      );
      if (currentUser?.uid == identity.uid) {
        _watchPublishedJobs(watchVersion);
        if (currentUser?.accountType == 'company') {
          await refreshCompanyJobs();
          await refreshCompanyApplications();
          await refreshNotifications();
        } else {
          await refreshApplications();
          await refreshNotifications();
        }
      }
    } catch (error) {
      authError = _errorMessage(error);
      notifyListeners();
    }
  }

  Future<void> loadLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString('languageCode');
    if (!_localeChanged && (languageCode == 'ar' || languageCode == 'en')) {
      locale = Locale(languageCode!);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale value) async {
    if (value.languageCode != 'ar' && value.languageCode != 'en') return;
    _localeChanged = true;
    if (locale != value) {
      locale = value;
      notifyListeners();
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('languageCode', value.languageCode);
  }

  Future<void> loadThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    final storedMode = preferences.getString('themeMode');
    if (!_themeModeChanged &&
        (storedMode == ThemeMode.light.name ||
            storedMode == ThemeMode.dark.name)) {
      themeMode = ThemeMode.values.byName(storedMode!);
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode value) async {
    _themeModeChanged = true;
    if (themeMode != value) {
      themeMode = value;
      notifyListeners();
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('themeMode', value.name);
  }

  Future<void> signIn({
    required String email,
    required String password,
    required String homeCountry,
    String accountType = 'employee',
  }) async {
    _validateEmailAndPassword(email, password);
    final identity = await _authRepository.signIn(
      email: email,
      password: password,
    );
    currentUser = AppUser(
      uid: identity.uid,
      name: identity.displayName ?? email.trim().split('@').first,
      email: identity.email ?? email.trim().toLowerCase(),
      homeCountry: homeCountry,
    );
    await _restoreProfileDetails(
      identity.uid,
      fallbackAccountType: accountType,
      createIfMissing: true,
    );
    if (currentUser?.accountType != accountType) {
      currentUser = null;
      await _authRepository.signOut();
      notifyListeners();
      throw StateError('This account uses a different account type.');
    }
    notifyListeners();
    await _refreshSignedInData();
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
    _validateEmailAndPassword(email, password);
    final identity = await _authRepository.createAccount(
      email: email,
      password: password,
      displayName: name,
    );
    currentUser = AppUser(
      uid: identity.uid,
      name: name.trim(),
      email: identity.email ?? email.trim().toLowerCase(),
      homeCountry: homeCountry,
    );
    try {
      await updateProfileDetails(
        birthdate: birthdate,
        governorate: governorate,
        governorateRegion: governorateRegion,
        academicAchievement: academicAchievement,
        workPreferences: workPreferences,
        workLocation: workLocation,
      );
    } catch (_) {
      currentUser = null;
      await _authRepository.signOut();
      rethrow;
    }
  }

  Future<void> signUpCompany({
    required String companyName,
    required String email,
    required String password,
    required String phone,
    required String responsiblePerson,
    required String governorate,
  }) async {
    _validateEmailAndPassword(email, password);
    final identity = await _authRepository.createAccount(
      email: email,
      password: password,
      displayName: companyName,
    );
    currentUser = AppUser(
      uid: identity.uid,
      name: companyName.trim(),
      email: identity.email ?? email.trim().toLowerCase(),
      accountType: 'company',
      homeCountry: 'Iraq',
      phone: phone,
      responsiblePerson: responsiblePerson,
      companyContactEmail: identity.email ?? email.trim().toLowerCase(),
      governorate: governorate,
    );
    try {
      await _saveAccountProfile(currentUser!);
      notifyListeners();
    } catch (_) {
      currentUser = null;
      await _authRepository.signOut();
      rethrow;
    }
  }

  void _validateEmailAndPassword(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if (!_isValidEmail(normalizedEmail)) {
      throw StateError('Enter a valid email address.');
    }
    if (password.length < 6) {
      throw StateError('Use a password of at least 6 characters.');
    }
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

  Future<void> sendPasswordResetEmail({required String email}) async {
    if (!_isValidEmail(email.trim())) {
      throw StateError('Enter a valid email address.');
    }
    await _authRepository.sendPasswordResetEmail(email: email);
  }

  Future<bool> updateAccount({
    required String name,
    required String email,
    String? currentPassword,
    String? newPassword,
  }) async {
    final user = currentUser;
    if (user == null) throw StateError('A signed-in user is required.');
    final normalizedEmail = email.trim().toLowerCase();
    if (!_isValidEmail(normalizedEmail)) {
      throw StateError('Enter a valid email address.');
    }
    final credentialsChanged = normalizedEmail != user.email ||
        (newPassword != null && newPassword.isNotEmpty);
    var emailChangePending = false;
    if (credentialsChanged) {
      if (currentPassword == null || currentPassword.isEmpty) {
        throw StateError('Enter your current password to continue.');
      }
      if (newPassword != null &&
          newPassword.isNotEmpty &&
          newPassword.length < 6) {
        throw StateError('Use a password of at least 6 characters.');
      }
      emailChangePending = await _authRepository.updateCredentials(
        currentPassword: currentPassword,
        email: normalizedEmail,
        newPassword: newPassword,
      );
    }
    user.name = name.trim();
    if (!emailChangePending) user.email = normalizedEmail;
    await _saveAccountProfile(user);
    if (emailChangePending) {
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
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
    if (user == null) throw StateError('A signed-in user is required.');
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
        'uid': user.uid,
        'name': user.name,
        'email': user.email,
        'accountType': user.accountType,
        'role': user.accountType,
        'homeCountry': user.homeCountry,
        'phone': user.phone,
        'responsiblePerson': user.responsiblePerson,
        'companyContactEmail': user.companyContactEmail,
        'birthdate': user.birthdate?.toIso8601String(),
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
        'cvStoragePath': user.cvStoragePath,
        'cvMimeType': user.cvMimeType,
        'cvFileSize': user.cvFileSize,
        'profileCompletion': user.profileCompletion,
      };

  Future<void> _saveAccountProfile(AppUser user) =>
      _accountRepository.saveAccount(user.uid, _accountData(user));

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
    if (user == null) return false;
    return _restoreProfileDetails(
      user.uid,
      fallbackAccountType: fallbackAccountType,
      createIfMissing: createIfMissing,
    );
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
      ..email = _authRepository.currentUser?.email ??
          (profile['email'] as String? ?? current.email)
      ..accountType = profile['accountType'] == 'company'
          ? 'company'
          : profile['accountType'] == 'employee'
              ? 'employee'
              : fallbackAccountType
      ..homeCountry = profile['homeCountry'] as String? ?? current.homeCountry
      ..phone = profile['phone'] as String?
      ..responsiblePerson = profile['responsiblePerson'] as String?
      ..companyContactEmail = profile['companyContactEmail'] as String?
      ..birthdate = birthdate is DateTime
          ? birthdate
          : birthdate is String
              ? DateTime.tryParse(birthdate)
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
      ..cvStoragePath = profile['cvStoragePath'] as String?
      ..cvMimeType = profile['cvMimeType'] as String?
      ..cvFileSize = profile['cvFileSize'] as int?
      ..profileCompletion =
          (profile['profileCompletion'] as num?)?.toDouble() ?? 0.2;
    notifyListeners();
    return true;
  }

  List<String> _stringList(Object? value) =>
      (value as List<dynamic>? ?? []).whereType<String>().toList();

  Future<void> attachCv({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    final user = currentUser;
    if (user == null) throw StateError('A signed-in user is required.');
    const maxSize = 5 * 1024 * 1024;
    if (bytes.isEmpty || bytes.length > maxSize) {
      throw StateError('Choose a CV file smaller than 5 MB.');
    }
    final storagePath = await _cvStorageRepository.upload(
      uid: user.uid,
      bytes: bytes,
      fileName: fileName,
      contentType: mimeType,
    );
    final oldValues = (
      user.cvFileName,
      user.cvStoragePath,
      user.cvMimeType,
      user.cvFileSize,
      user.profileCompletion,
    );
    user
      ..cvFileName = fileName
      ..cvStoragePath = storagePath
      ..cvMimeType = mimeType
      ..cvFileSize = bytes.length
      ..profileCompletion = 0.65;
    try {
      await _saveAccountProfile(user);
    } catch (_) {
      user
        ..cvFileName = oldValues.$1
        ..cvStoragePath = oldValues.$2
        ..cvMimeType = oldValues.$3
        ..cvFileSize = oldValues.$4
        ..profileCompletion = oldValues.$5;
      rethrow;
    }
    notifyListeners();
  }

  Future<void> completeProfile() async {
    final user = currentUser;
    if (user == null) throw StateError('A signed-in user is required.');
    user.profileCompletion = 1.0;
    await _saveAccountProfile(user);
    notifyListeners();
  }

  Future<void> _refreshSignedInData() async {
    if (currentUser?.accountType == 'company') {
      await refreshCompanyJobs();
      await refreshCompanyApplications();
      await refreshNotifications();
    } else {
      await refreshJobs();
      await refreshApplications();
      await refreshNotifications();
    }
  }

  Future<void> refreshJobs() async {
    jobsLoading = true;
    jobsError = null;
    notifyListeners();
    try {
      jobs = await _marketplaceRepository.getPublishedJobs();
    } catch (error) {
      jobsError = _errorMessage(error);
    } finally {
      jobsLoading = false;
      notifyListeners();
    }
  }

  void _watchPublishedJobs(int watchVersion) {
    jobsLoading = true;
    jobsError = null;
    notifyListeners();
    _jobsSubscription = _marketplaceRepository.watchPublishedJobs().listen(
      (publishedJobs) {
        if (watchVersion != _jobWatchVersion) return;
        jobs = publishedJobs;
        jobsLoading = false;
        jobsError = null;
        notifyListeners();
      },
      onError: (Object error) {
        if (watchVersion != _jobWatchVersion) return;
        jobsError = _errorMessage(error);
        jobsLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> refreshCompanyJobs() async {
    jobsLoading = true;
    jobsError = null;
    notifyListeners();
    try {
      companyJobs = await _marketplaceRepository.getCompanyJobs();
    } catch (error) {
      jobsError = _errorMessage(error);
    } finally {
      jobsLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshApplications() async {
    applicationsLoading = true;
    applicationsError = null;
    notifyListeners();
    try {
      applications = await _marketplaceRepository.getCandidateApplications();
    } catch (error) {
      applicationsError = _errorMessage(error);
    } finally {
      applicationsLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCompanyApplications() async {
    applicationsLoading = true;
    applicationsError = null;
    notifyListeners();
    try {
      companyApplications =
          await _marketplaceRepository.getCompanyApplications();
    } catch (error) {
      applicationsError = _errorMessage(error);
    } finally {
      applicationsLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    notificationsLoading = true;
    notificationsError = null;
    notifyListeners();
    try {
      notifications = await _marketplaceRepository.getNotifications();
    } catch (error) {
      notificationsError = _errorMessage(error);
    } finally {
      notificationsLoading = false;
      notifyListeners();
    }
  }

  Future<Job> createJob({
    required String title,
    required String location,
    required String type,
    required String salaryRange,
    required String experience,
    required String description,
    required List<String> skills,
  }) async {
    final company = currentUser;
    if (company == null || company.accountType != 'company') {
      throw StateError('A signed-in company account is required.');
    }
    final job = await _marketplaceRepository.createJob(
      Job(
        id: '',
        companyId: company.uid,
        title: title,
        company: company.name,
        location: location,
        salaryRange: salaryRange,
        type: type,
        tags: skills,
        postedAt: DateTime.now(),
        description: description,
        experience: experience,
      ),
    );
    return job;
  }

  Future<void> closeJob(String jobId) async {
    await _marketplaceRepository.closeJob(jobId);
    jobs = jobs.where((job) => job.id != jobId).toList();
    companyJobs = companyJobs.where((job) => job.id != jobId).toList();
    notifyListeners();
  }

  Future<void> requestApplication(Job job) async {
    if (currentUser == null || currentUser!.accountType != 'employee') {
      throw StateError('Sign in with an employee account to continue.');
    }
    await _marketplaceRepository.requestApplication(job);
    await refreshApplications();
  }

  Future<void> submitManualApplication(Job job) async {
    if (currentUser == null || currentUser!.accountType != 'employee') {
      throw StateError('Sign in with an employee account to continue.');
    }
    await _marketplaceRepository.submitManualApplication(job);
    await refreshApplications();
  }

  Future<void> updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  ) async {
    await _marketplaceRepository.updateApplicationStatus(applicationId, status);
    await refreshCompanyApplications();
  }

  static String _errorMessage(Object error) {
    final text = error.toString();
    return text.startsWith('Bad state: ') ? text.substring(11) : text;
  }

  static String errorMessage(Object error) => _errorMessage(error);

  Future<void> signOut() async {
    await _authRepository.signOut();
    currentUser = null;
    applications = [];
    companyApplications = [];
    notifications = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _jobWatchVersion++;
    unawaited(_jobsSubscription?.cancel());
    unawaited(_authSubscription?.cancel());
    super.dispose();
  }
}
