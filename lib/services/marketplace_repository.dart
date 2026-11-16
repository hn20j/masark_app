import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/models.dart';

abstract interface class MarketplaceRepository {
  Future<List<Job>> getPublishedJobs();
  Stream<List<Job>> watchPublishedJobs();
  Future<List<Job>> getCompanyJobs();
  Future<List<Application>> getCandidateApplications();
  Future<List<Application>> getCompanyApplications();
  Future<List<AppNotification>> getNotifications();
  Future<Job> createJob(Job job);
  Future<void> closeJob(String jobId);
  Future<void> requestApplication(Job job);
  Future<void> submitManualApplication(Job job);
  Future<void> updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  );
}

class FirebaseMarketplaceRepository implements MarketplaceRepository {
  FirebaseMarketplaceRepository()
      : _firestore = FirebaseFirestore.instance,
        _functions = FirebaseFunctions.instance,
        _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  static MarketplaceRepository createDefault() => Firebase.apps.isEmpty
      ? const UnavailableMarketplaceRepository()
      : FirebaseMarketplaceRepository();

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('A signed-in user is required.');
    return uid;
  }

  @override
  Future<List<Job>> getPublishedJobs() async {
    final result = await _firestore
        .collection('jobs')
        .where('status', isEqualTo: 'published')
        .get();
    return _sortedJobs(result.docs);
  }

  @override
  Stream<List<Job>> watchPublishedJobs() => _firestore
      .collection('jobs')
      .where('status', isEqualTo: 'published')
      .snapshots()
      .map((snapshot) => _sortedJobs(snapshot.docs));

  List<Job> _sortedJobs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) =>
      documents.map(_jobFromDocument).toList()
        ..sort((a, b) => b.postedAt.compareTo(a.postedAt));

  @override
  Future<List<Job>> getCompanyJobs() async {
    final result = await _firestore
        .collection('jobs')
        .where('companyId', isEqualTo: _uid)
        .get();
    return _sortedJobs(result.docs);
  }

  @override
  Future<List<Application>> getCandidateApplications() async {
    final result = await _firestore
        .collection('applications')
        .where('candidateId', isEqualTo: _uid)
        .get();
    return _applicationsFromDocuments(result.docs);
  }

  @override
  Future<List<Application>> getCompanyApplications() async {
    final result = await _firestore
        .collection('applications')
        .where('companyId', isEqualTo: _uid)
        .get();
    return _applicationsFromDocuments(result.docs);
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    final result = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .get();
    return result.docs.map((document) {
      final data = document.data();
      return AppNotification(
        id: document.id,
        title: data['title'] as String? ?? '',
        body: data['body'] as String? ?? '',
        createdAt: _dateTime(data['createdAt']),
        read: data['read'] as bool? ?? false,
      );
    }).toList();
  }

  @override
  Future<Job> createJob(Job job) async {
    final uid = _uid;
    final reference = await _firestore.collection('jobs').add({
      'companyId': uid,
      'company': job.company,
      'title': job.title,
      'location': job.location,
      'salaryRange': job.salaryRange,
      'type': job.type,
      'tags': job.tags,
      'description': job.description ?? '',
      'experience': job.experience ?? '',
      'status': 'published',
      'postedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return Job(
      id: reference.id,
      companyId: uid,
      title: job.title,
      company: job.company,
      location: job.location,
      salaryRange: job.salaryRange,
      type: job.type,
      tags: job.tags,
      postedAt: job.postedAt,
      description: job.description,
      experience: job.experience,
    );
  }

  @override
  Future<void> closeJob(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).update({
      'status': 'closed',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> requestApplication(Job job) => _createApplication(
        job,
        status: 'queued',
        source: 'apply_for_me',
      );

  @override
  Future<void> submitManualApplication(Job job) => _createApplication(
        job,
        status: 'submitted',
        source: 'manual',
      );

  Future<void> _createApplication(
    Job job, {
    required String status,
    required String source,
  }) async {
    final uid = _uid;
    final userSnapshot = await _firestore.collection('users').doc(uid).get();
    final user = userSnapshot.data();
    if (!userSnapshot.exists ||
        user == null ||
        user['accountType'] != 'employee' ||
        user['email'] is! String) {
      throw StateError('A signed-in employee account is required to apply.');
    }

    final jobSnapshot = await _firestore.collection('jobs').doc(job.id).get();
    final jobData = jobSnapshot.data();
    if (!jobSnapshot.exists || jobData?['status'] != 'published') {
      throw StateError('This job is no longer available.');
    }

    final applicationReference =
        _firestore.collection('applications').doc('${uid}_${job.id}');
    if ((await applicationReference.get()).exists) {
      throw StateError('You already have an application for this job.');
    }

    try {
      await applicationReference.set({
        'candidateId': uid,
        'candidateName': user['name'] as String? ?? '',
        'candidateEmail': user['email'] as String,
        'companyId': jobData?['companyId'],
        'companyName': jobData?['company'],
        'jobId': job.id,
        'jobTitle': jobData?['title'],
        'jobLocation': jobData?['location'],
        'salaryRange': jobData?['salaryRange'],
        'jobType': jobData?['type'],
        'status': status,
        'source': source,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied' &&
          (await applicationReference.get()).exists) {
        throw StateError('You already have an application for this job.');
      }
      throw StateError(
        'Could not submit your application: ${error.message ?? error.code}',
      );
    }
  }

  @override
  Future<void> updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  ) async {
    try {
      await _functions.httpsCallable('updateApplicationStatus').call({
        'applicationId': applicationId,
        'status': _statusName(status),
      });
    } on FirebaseFunctionsException catch (error) {
      throw StateError(
        _functionError(error, 'Could not update the application status.'),
      );
    }
  }

  List<Application> _applicationsFromDocuments(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) {
    final applications = documents.map((document) {
      final data = document.data();
      final job = Job(
        id: data['jobId'] as String? ?? '',
        companyId: data['companyId'] as String?,
        title: data['jobTitle'] as String? ?? '',
        company: data['companyName'] as String? ?? '',
        location: data['jobLocation'] as String? ?? '',
        salaryRange: data['salaryRange'] as String? ?? '',
        type: data['jobType'] as String? ?? '',
        tags: const [],
        postedAt: _dateTime(data['createdAt']),
      );
      return Application(
        id: document.id,
        job: job,
        status: _applicationStatus(data['status']),
        submittedAt: _dateTime(data['createdAt']),
        candidateId: data['candidateId'] as String?,
        candidateName: data['candidateName'] as String?,
        candidateEmail: data['candidateEmail'] as String?,
        companyId: data['companyId'] as String?,
        submittedByAgent: data['source'] == 'apply_for_me',
      );
    }).toList()
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    return applications;
  }

  Job _jobFromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    return Job(
      id: document.id,
      companyId: data['companyId'] as String?,
      title: data['title'] as String? ?? '',
      company: data['company'] as String? ?? '',
      location: data['location'] as String? ?? '',
      salaryRange: data['salaryRange'] as String? ?? '',
      type: data['type'] as String? ?? '',
      tags: _stringList(data['tags']),
      postedAt: _dateTime(data['postedAt']),
      description: data['description'] as String?,
      experience: data['experience'] as String?,
    );
  }

  static List<String> _stringList(Object? value) =>
      value is List ? value.whereType<String>().toList() : const [];

  static DateTime _dateTime(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  static ApplicationStatus _applicationStatus(Object? value) => switch (value) {
        'submitted' => ApplicationStatus.submitted,
        'viewed' => ApplicationStatus.viewed,
        'interview' => ApplicationStatus.interview,
        'rejected' => ApplicationStatus.rejected,
        'offer' => ApplicationStatus.offer,
        _ => ApplicationStatus.queued,
      };

  static String _statusName(ApplicationStatus status) => switch (status) {
        ApplicationStatus.queued => 'queued',
        ApplicationStatus.submitted => 'submitted',
        ApplicationStatus.viewed => 'viewed',
        ApplicationStatus.interview => 'interview',
        ApplicationStatus.rejected => 'rejected',
        ApplicationStatus.offer => 'offer',
      };

  static String _functionError(
    FirebaseFunctionsException error,
    String fallback,
  ) {
    if (error.code == 'not-found' || error.code == 'unavailable') {
      return 'The application service is not deployed yet. Your request was '
          'not submitted to the company.';
    }
    return error.message ?? fallback;
  }
}

class UnavailableMarketplaceRepository implements MarketplaceRepository {
  const UnavailableMarketplaceRepository();

  StateError _unavailable() => StateError(
        'Firebase is not configured. Configure this app with FlutterFire to '
        'load jobs, applications, and notifications.',
      );

  @override
  Future<List<Job>> getPublishedJobs() => Future.error(_unavailable());

  @override
  Stream<List<Job>> watchPublishedJobs() =>
      Stream<List<Job>>.error(_unavailable());

  @override
  Future<List<Job>> getCompanyJobs() => Future.error(_unavailable());

  @override
  Future<List<Application>> getCandidateApplications() =>
      Future.error(_unavailable());

  @override
  Future<List<Application>> getCompanyApplications() =>
      Future.error(_unavailable());

  @override
  Future<List<AppNotification>> getNotifications() =>
      Future.error(_unavailable());

  @override
  Future<Job> createJob(Job job) => Future.error(_unavailable());

  @override
  Future<void> closeJob(String jobId) => Future.error(_unavailable());

  @override
  Future<void> requestApplication(Job job) => Future.error(_unavailable());

  @override
  Future<void> submitManualApplication(Job job) => Future.error(_unavailable());

  @override
  Future<void> updateApplicationStatus(
    String applicationId,
    ApplicationStatus status,
  ) =>
      Future.error(_unavailable());
}
