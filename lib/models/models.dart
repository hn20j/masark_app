/// Shared account and job models used by app state and Firebase-backed screens.
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
  final int matchScore; // 0-100, how well it matches the user's CV

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salaryRange,
    required this.type,
    required this.tags,
    required this.postedAt,
    required this.matchScore,
  });
}

enum ApplicationStatus { queued, submitted, viewed, interview, rejected, offer }

class Application {
  final String id;
  final Job job;
  ApplicationStatus status;
  final DateTime submittedAt;
  final bool submittedByAgent;

  Application({
    required this.id,
    required this.job,
    required this.status,
    required this.submittedAt,
    this.submittedByAgent = true,
  });
}

/// Sample/demo data so every screen renders meaningfully without a backend.
class DemoData {
  DemoData._();

  static List<Job> jobs = [
    Job(
      id: 'j1',
      title: 'مطوّر تطبيقات Flutter',
      company: 'شركة نبراس التقنية',
      location: 'بغداد، العراق',
      salaryRange: '1,500 - 2,200 \$',
      type: 'دوام كامل',
      tags: const ['Flutter', 'Dart', 'Mobile'],
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      matchScore: 92,
    ),
    Job(
      id: 'j2',
      title: 'محلل بيانات',
      company: 'مجموعة الرافدين المالية',
      location: 'أربيل، العراق',
      salaryRange: '1,200 - 1,800 \$',
      type: 'دوام كامل',
      tags: const ['SQL', 'Power BI', 'Excel'],
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      matchScore: 81,
    ),
    Job(
      id: 'j3',
      title: 'أخصائي تسويق رقمي',
      company: 'داماس ميديا',
      location: 'دبي، الإمارات (عن بعد)',
      salaryRange: '900 - 1,400 \$',
      type: 'عن بعد',
      tags: const ['SEO', 'Ads', 'Content'],
      postedAt: DateTime.now().subtract(const Duration(hours: 10)),
      matchScore: 74,
    ),
    Job(
      id: 'j4',
      title: 'مهندس شبكات',
      company: 'اتصالات الشرق',
      location: 'البصرة، العراق',
      salaryRange: '1,100 - 1,600 \$',
      type: 'دوام كامل',
      tags: const ['Cisco', 'Networking'],
      postedAt: DateTime.now().subtract(const Duration(days: 4)),
      matchScore: 65,
    ),
  ];

  static List<Application> applications = [
    Application(
      id: 'a1',
      job: jobs[0],
      status: ApplicationStatus.interview,
      submittedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Application(
      id: 'a2',
      job: jobs[1],
      status: ApplicationStatus.submitted,
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Application(
      id: 'a3',
      job: jobs[3],
      status: ApplicationStatus.viewed,
      submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
}
