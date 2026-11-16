/// Shared account and job models used by app state and screens.
library;

class AppUser {
  String uid;
  String name;
  String email;
  String accountType;
  String homeCountry;
  String? phone;
  String? responsiblePerson;
  String? companyContactEmail;
  DateTime? birthdate;
  String? governorate;
  String? governorateRegion;
  String? academicAchievement;
  List<String> workPreferences;
  String? workLocation;
  List<String> skills;
  String? careerCategory;
  String? universityMajor;
  String? yearsExperience;
  String preferredCountry;
  bool remoteOk;
  String? cvFileName;
  String? cvFilePath;
  String? cvStoragePath;
  String? cvMimeType;
  int? cvFileSize;
  double profileCompletion;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.accountType = 'employee',
    required this.homeCountry,
    this.phone,
    this.responsiblePerson,
    this.companyContactEmail,
    this.birthdate,
    this.governorate,
    this.governorateRegion,
    this.academicAchievement,
    List<String>? workPreferences,
    this.workLocation,
    List<String>? skills,
    this.careerCategory,
    this.universityMajor,
    this.yearsExperience,
    this.preferredCountry = 'Iraq',
    this.remoteOk = true,
    this.cvFileName,
    this.cvFilePath,
    this.cvStoragePath,
    this.cvMimeType,
    this.cvFileSize,
    this.profileCompletion = 0.2,
  })  : workPreferences = workPreferences ?? [],
        skills = skills ?? [];
}

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salaryRange;
  final String type; // full-time / remote / part-time
  final List<String> tags;
  final DateTime postedAt;
  final int? matchScore;
  final String? companyId;
  final String? description;
  final String? experience;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salaryRange,
    required this.type,
    required this.tags,
    required this.postedAt,
    this.matchScore,
    this.companyId,
    this.description,
    this.experience,
  });
}

enum ApplicationStatus { queued, submitted, viewed, interview, rejected, offer }

class Application {
  final String id;
  final Job job;
  ApplicationStatus status;
  final DateTime submittedAt;
  final bool submittedByAgent;
  final String? candidateId;
  final String? candidateName;
  final String? candidateEmail;
  final String? companyId;

  Application({
    required this.id,
    required this.job,
    required this.status,
    required this.submittedAt,
    this.submittedByAgent = false,
    this.candidateId,
    this.candidateName,
    this.candidateEmail,
    this.companyId,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
  });
}
