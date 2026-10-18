import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../theme/app_state.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';

enum _CompanyTab { dashboard, jobs, applicants, interviews, company }

enum _CandidateStage { newApplicant, underReview, interview, hired, rejected }

class CompanyJob {
  final String title;
  final String location;
  final String type;
  final String salary;
  final String experience;
  final String description;
  final List<String> skills;
  final DateTime postedAt;

  const CompanyJob({
    required this.title,
    required this.location,
    required this.type,
    required this.salary,
    required this.experience,
    required this.description,
    required this.skills,
    required this.postedAt,
  });
}

class _CompanyCandidate {
  final String name;
  final String role;
  final String email;
  final String jobTitle;
  _CandidateStage stage;
  DateTime? interviewAt;

  _CompanyCandidate({
    required this.name,
    required this.role,
    required this.email,
    required this.jobTitle,
    required this.stage,
    this.interviewAt,
  });
}

class CompanyDashboardScreen extends StatefulWidget {
  final String companyName;
  final String email;
  final String phone;
  final String responsiblePerson;
  final String governorate;

  const CompanyDashboardScreen({
    super.key,
    required this.companyName,
    required this.email,
    required this.phone,
    required this.responsiblePerson,
    required this.governorate,
  });

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  _CompanyTab _tab = _CompanyTab.dashboard;
  late String _companyName = widget.companyName;
  late String _email = widget.email;
  late String _phone = widget.phone;
  late String _responsiblePerson = widget.responsiblePerson;
  late String _governorate = widget.governorate;

  final List<CompanyJob> _jobs = [
    CompanyJob(
      title: 'Flutter Developer',
      location: 'Baghdad',
      type: 'Full-time',
      salary: 'Negotiable',
      experience: '2+ years',
      description: 'Build and maintain mobile applications.',
      skills: const ['Flutter', 'Dart'],
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    CompanyJob(
      title: 'Product Designer',
      location: 'Erbil',
      type: 'Full-time',
      salary: 'Negotiable',
      experience: '1+ year',
      description: 'Design helpful digital products for our customers.',
      skills: const ['Figma', 'UI/UX'],
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  late final List<_CompanyCandidate> _candidates = [
    _CompanyCandidate(
      name: 'Sara Ahmed',
      role: 'Flutter Developer',
      email: 'sara.ahmed@example.com',
      jobTitle: 'Flutter Developer',
      stage: _CandidateStage.newApplicant,
    ),
    _CompanyCandidate(
      name: 'Omar Khalid',
      role: 'Flutter Developer',
      email: 'omar.khalid@example.com',
      jobTitle: 'Flutter Developer',
      stage: _CandidateStage.underReview,
    ),
    _CompanyCandidate(
      name: 'Noor Ali',
      role: 'Product Designer',
      email: 'noor.ali@example.com',
      jobTitle: 'Product Designer',
      stage: _CandidateStage.interview,
      interviewAt: DateTime.now().add(const Duration(days: 1)),
    ),
  ];

  String _tabTitle(BuildContext context) => switch (_tab) {
        _CompanyTab.dashboard =>
          AppText.of(context, 'لوحة التحكم', 'Dashboard'),
        _CompanyTab.jobs => AppText.of(context, 'الوظائف', 'Jobs'),
        _CompanyTab.applicants =>
          AppText.of(context, 'المتقدمون', 'Applicants'),
        _CompanyTab.interviews =>
          AppText.of(context, 'المقابلات', 'Interviews'),
        _CompanyTab.company => AppText.of(context, 'ملف الشركة', 'Company'),
      };

  void _selectTab(_CompanyTab tab) => setState(() => _tab = tab);

  Future<void> _createJob() async {
    final job = await Navigator.of(context).push<CompanyJob>(
      MaterialPageRoute(builder: (_) => const CompanyJobFormScreen()),
    );
    if (job != null && mounted) {
      setState(() {
        _jobs.insert(0, job);
        _tab = _CompanyTab.jobs;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppText.of(
            context,
            'تمت إضافة الوظيفة إلى لوحة التحكم.',
            'Job added to your dashboard.',
          )),
        ),
      );
    }
  }

  Future<void> _editCompanyProfile() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: _companyName);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);
    final contactController = TextEditingController(text: _responsiblePerson);
    final locationController = TextEditingController(text: _governorate);
    try {
      final updated = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.surfaceIndigo,
          title: Text(AppText.of(
            dialogContext,
            'تعديل معلومات الشركة',
            'Edit company details',
          )),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _profileField(
                    dialogContext,
                    nameController,
                    AppText.of(dialogContext, 'اسم الشركة', 'Company name'),
                    maxLength: 120,
                  ),
                  _profileField(
                    dialogContext,
                    emailController,
                    AppText.of(dialogContext, 'البريد الإلكتروني', 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 254,
                  ),
                  _profileField(
                    dialogContext,
                    phoneController,
                    AppText.of(dialogContext, 'رقم الهاتف', 'Phone number'),
                    keyboardType: TextInputType.phone,
                    maxLength: 32,
                  ),
                  _profileField(
                    dialogContext,
                    contactController,
                    AppText.of(
                      dialogContext,
                      'الشخص المسؤول عن التوظيف',
                      'Hiring contact',
                    ),
                    maxLength: 120,
                  ),
                  _profileField(
                    dialogContext,
                    locationController,
                    AppText.of(dialogContext, 'المحافظة', 'Governorate'),
                    maxLength: 100,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(AppText.of(dialogContext, 'إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: Text(AppText.of(dialogContext, 'حفظ', 'Save')),
            ),
          ],
        ),
      );

      if (updated == true && mounted) {
        try {
          await context.read<AppState>().updateCompanyProfile(
                companyName: nameController.text.trim(),
                contactEmail: emailController.text.trim(),
                phone: phoneController.text.trim(),
                responsiblePerson: contactController.text.trim(),
                governorate: locationController.text.trim(),
              );
          if (!mounted) return;
          setState(() {
            _companyName = nameController.text.trim();
            _email = emailController.text.trim();
            _phone = phoneController.text.trim();
            _responsiblePerson = contactController.text.trim();
            _governorate = locationController.text.trim();
          });
        } on FirebaseException {
          if (!mounted) return;
          _showNotice(
            AppText.of(
              context,
              'تعذر حفظ معلومات الشركة. تحقق من اتصالك وحاول مجددًا.',
              'Could not save company details. Check your connection and try again.',
            ),
          );
        }
      }
    } finally {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      contactController.dispose();
      locationController.dispose();
    }
  }

  Widget _profileField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textDark),
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) {
            return AppText.of(
              context,
              'هذا الحقل مطلوب.',
              'Required field.',
            );
          }
          if (keyboardType == TextInputType.emailAddress &&
              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
            return AppText.of(
              context,
              'أدخل بريدًا إلكترونيًا صالحًا.',
              'Enter a valid email address.',
            );
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_tabTitle(context)),
        actions: [
          IconButton(
            tooltip: AppText.of(context, 'إشعارات', 'Notifications'),
            onPressed: () => _showNotice(
              AppText.of(
                  context, 'لا توجد إشعارات جديدة', 'No new notifications'),
            ),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _tab.index,
          children: [
            _OverviewTab(
              companyName: _companyName,
              jobs: _jobs,
              candidates: _candidates,
              onPostJob: _createJob,
              onOpenJobs: () => _selectTab(_CompanyTab.jobs),
              onOpenApplicants: () => _selectTab(_CompanyTab.applicants),
              onOpenInterviews: () => _selectTab(_CompanyTab.interviews),
            ),
            _JobsTab(
              jobs: _jobs,
              onPostJob: _createJob,
              onCloseJob: (job) => setState(() => _jobs.remove(job)),
            ),
            _ApplicantsTab(
              candidates: _candidates,
              onStageChanged: (candidate, stage) =>
                  setState(() => candidate.stage = stage),
              onSchedule: _scheduleInterview,
            ),
            _InterviewsTab(
              candidates: _candidates
                  .where((candidate) =>
                      candidate.stage == _CandidateStage.interview)
                  .toList(),
              onSchedule: _scheduleInterview,
              onMarkDone: (candidate) => setState(
                () => candidate.stage = _CandidateStage.hired,
              ),
            ),
            _CompanyProfileTab(
              companyName: _companyName,
              email: _email,
              phone: _phone,
              responsiblePerson: _responsiblePerson,
              governorate: _governorate,
              onEdit: _editCompanyProfile,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab.index,
        onTap: (index) => setState(() => _tab = _CompanyTab.values[index]),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            label: AppText.of(context, 'الرئيسية', 'Home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.work_outline),
            label: AppText.of(context, 'الوظائف', 'Jobs'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            label: AppText.of(context, 'المتقدمون', 'Applicants'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.event_outlined),
            label: AppText.of(context, 'المقابلات', 'Interviews'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.business_outlined),
            label: AppText.of(context, 'الشركة', 'Company'),
          ),
        ],
      ),
    );
  }

  Future<void> _scheduleInterview(_CompanyCandidate candidate) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: candidate.interviewAt ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: candidate.interviewAt == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(candidate.interviewAt!),
    );
    if (time == null || !mounted) return;
    setState(() {
      candidate
        ..stage = _CandidateStage.interview
        ..interviewAt = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
    });
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _OverviewTab extends StatelessWidget {
  final String companyName;
  final List<CompanyJob> jobs;
  final List<_CompanyCandidate> candidates;
  final VoidCallback onPostJob;
  final VoidCallback onOpenJobs;
  final VoidCallback onOpenApplicants;
  final VoidCallback onOpenInterviews;

  const _OverviewTab({
    required this.companyName,
    required this.jobs,
    required this.candidates,
    required this.onPostJob,
    required this.onOpenJobs,
    required this.onOpenApplicants,
    required this.onOpenInterviews,
  });

  @override
  Widget build(BuildContext context) {
    final reviewCount = candidates
        .where((candidate) =>
            candidate.stage == _CandidateStage.newApplicant ||
            candidate.stage == _CandidateStage.underReview)
        .length;
    final interviewCount = candidates
        .where((candidate) => candidate.stage == _CandidateStage.interview)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          '${AppText.of(context, 'مرحبًا،', 'Welcome,')} $companyName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppText.of(
            context,
            'إليك ملخص نشاط التوظيف لديك',
            'Here is your hiring activity at a glance',
          ),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.surfaceIndigoLight,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.accentPink,
                size: 19,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppText.of(
                    context,
                    'الوظائف والمتقدمون الظاهرون بيانات تجريبية. إعلاناتك الجديدة تُحفظ مؤقتًا على هذا الجهاز.',
                    'The jobs and applicants shown are examples. New job posts are stored temporarily on this device.',
                  ),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.work_outline,
                value: '${jobs.length}',
                label: AppText.of(context, 'وظائف منشورة', 'Open jobs'),
                onTap: onOpenJobs,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.people_outline,
                value: '${candidates.length}',
                label: AppText.of(context, 'إجمالي المتقدمين', 'Applicants'),
                onTap: onOpenApplicants,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.rate_review_outlined,
                value: '$reviewCount',
                label: AppText.of(context, 'قيد المراجعة', 'Under review'),
                onTap: onOpenApplicants,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.event_available_outlined,
                value: '$interviewCount',
                label: AppText.of(context, 'مقابلات قادمة', 'Interviews'),
                onTap: onOpenInterviews,
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        _SectionHeading(
          title: AppText.of(context, 'إجراءات سريعة', 'Quick actions'),
        ),
        const SizedBox(height: 12),
        _QuickAction(
          icon: Icons.add_circle_outline,
          title: AppText.of(context, 'أضف وظيفة جديدة', 'Post a new job'),
          subtitle: AppText.of(
            context,
            'أنشئ متطلبًا وظيفيًا وانشره',
            'Create and publish a job requirement',
          ),
          onTap: onPostJob,
        ),
        const SizedBox(height: 10),
        _QuickAction(
          icon: Icons.person_search_outlined,
          title: AppText.of(context, 'راجع المتقدمين', 'Review applicants'),
          subtitle: AppText.of(
            context,
            'افحص المرشحين وحدّث حالة طلباتهم',
            'Review candidates and update their status',
          ),
          onTap: onOpenApplicants,
        ),
        const SizedBox(height: 10),
        _QuickAction(
          icon: Icons.event_outlined,
          title:
              AppText.of(context, 'المقابلات القادمة', 'Upcoming interviews'),
          subtitle: AppText.of(
            context,
            'تابع مواعيد مقابلات المرشحين',
            'Keep track of candidate interview times',
          ),
          onTap: onOpenInterviews,
        ),
        const SizedBox(height: 24),
        _SectionHeading(
          title: AppText.of(context, 'أحدث الوظائف', 'Recent jobs'),
          action: TextButton(
            onPressed: onOpenJobs,
            child: Text(AppText.of(context, 'عرض الكل', 'View all')),
          ),
        ),
        const SizedBox(height: 8),
        if (jobs.isEmpty)
          _EmptyState(
            icon: Icons.work_outline,
            message: AppText.of(
              context,
              'لا توجد وظائف منشورة. أضف أول وظيفة لتبدأ.',
              'No jobs posted yet. Add your first job to get started.',
            ),
          )
        else
          ...jobs.take(3).map((job) => _JobCard(job: job)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceIndigoLight,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.accentPink, size: 21),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobsTab extends StatelessWidget {
  final List<CompanyJob> jobs;
  final VoidCallback onPostJob;
  final ValueChanged<CompanyJob> onCloseJob;

  const _JobsTab({
    required this.jobs,
    required this.onPostJob,
    required this.onCloseJob,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: AppText.of(context, 'نشر وظيفة جديدة', 'Post a new job'),
              icon: Icons.add,
              onPressed: onPostJob,
            ),
          ),
        ),
        Expanded(
          child: jobs.isEmpty
              ? _EmptyState(
                  icon: Icons.work_outline,
                  message: AppText.of(
                    context,
                    'لا توجد وظائف منشورة بعد.',
                    'No jobs have been posted yet.',
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: jobs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _JobCard(
                    job: jobs[index],
                    onClose: () => onCloseJob(jobs[index]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _JobCard extends StatelessWidget {
  final CompanyJob job;
  final VoidCallback? onClose;

  const _JobCard({required this.job, this.onClose});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final jobType = switch (job.type) {
      'Full-time' => AppText.of(context, 'دوام كامل', 'Full-time'),
      'Part-time' => AppText.of(context, 'دوام جزئي', 'Part-time'),
      'Contract' => AppText.of(context, 'عقد', 'Contract'),
      'Remote' => AppText.of(context, 'عن بُعد', 'Remote'),
      _ => job.type,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceIndigo,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (onClose != null)
                PopupMenuButton<String>(
                  tooltip: AppText.of(context, 'خيارات الوظيفة', 'Job options'),
                  onSelected: (action) async {
                    if (action != 'close') return;
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Text(AppText.of(
                          dialogContext,
                          'إغلاق الوظيفة؟',
                          'Close this job?',
                        )),
                        content: Text(AppText.of(
                          dialogContext,
                          'ستتم إزالة الوظيفة من قائمتك الحالية.',
                          'This will remove the job from your current list.',
                        )),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(
                                AppText.of(dialogContext, 'إلغاء', 'Cancel')),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: Text(
                                AppText.of(dialogContext, 'إغلاق', 'Close')),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) onClose!();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'close',
                      child: Text(
                          AppText.of(context, 'إغلاق الوظيفة', 'Close job')),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              _InfoLabel(icon: Icons.location_on_outlined, label: job.location),
              _InfoLabel(icon: Icons.schedule_outlined, label: jobType),
              if (job.salary.isNotEmpty)
                _InfoLabel(icon: Icons.payments_outlined, label: job.salary),
            ],
          ),
          if (job.experience.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '${AppText.of(context, 'الخبرة:', 'Experience:')} ${job.experience}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
          if (job.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              job.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
          if (job.skills.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: job.skills
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: AppColors.surfaceIndigoLight,
                      side: BorderSide.none,
                      labelStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 7),
          Text(
            AppText.of(
              context,
              'نُشرت ${_timeAgo(job.postedAt, isArabic)}',
              'Posted ${_timeAgo(job.postedAt, false)}',
            ),
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ApplicantsTab extends StatefulWidget {
  final List<_CompanyCandidate> candidates;
  final void Function(_CompanyCandidate, _CandidateStage) onStageChanged;
  final ValueChanged<_CompanyCandidate> onSchedule;

  const _ApplicantsTab({
    required this.candidates,
    required this.onStageChanged,
    required this.onSchedule,
  });

  @override
  State<_ApplicantsTab> createState() => _ApplicantsTabState();
}

class _ApplicantsTabState extends State<_ApplicantsTab> {
  _CandidateStage? _filter;

  @override
  Widget build(BuildContext context) {
    final candidates = widget.candidates
        .where((candidate) => _filter == null || candidate.stage == _filter)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          child: Text(
            AppText.of(
              context,
              '${widget.candidates.length} طلب توظيف',
              '${widget.candidates.length} applications',
            ),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              _ApplicantFilter(
                label: AppText.of(context, 'الكل', 'All'),
                selected: _filter == null,
                onTap: () => setState(() => _filter = null),
              ),
              for (final stage in _CandidateStage.values)
                _ApplicantFilter(
                  label: _stageLabel(context, stage),
                  selected: _filter == stage,
                  onTap: () => setState(() => _filter = stage),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: candidates.isEmpty
              ? _EmptyState(
                  icon: Icons.person_search_outlined,
                  message: AppText.of(
                    context,
                    'لا يوجد متقدمون في هذه المرحلة.',
                    'No applicants in this stage.',
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: candidates.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _CandidateCard(
                    candidate: candidates[index],
                    onStageChanged: (stage) =>
                        widget.onStageChanged(candidates[index], stage),
                    onSchedule: () => widget.onSchedule(candidates[index]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ApplicantFilter extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ApplicantFilter({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.accentPink,
        backgroundColor: AppColors.surfaceIndigoLight,
        labelStyle: TextStyle(
          color: selected ? AppColors.surfaceIndigo : AppColors.textSecondary,
          fontSize: 11,
        ),
        side: BorderSide.none,
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final _CompanyCandidate candidate;
  final ValueChanged<_CandidateStage> onStageChanged;
  final VoidCallback onSchedule;

  const _CandidateCard({
    required this.candidate,
    required this.onStageChanged,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surfaceIndigo,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.surfaceIndigoLight,
                child: Text(
                  candidate.name.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.accentPink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      candidate.role,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_CandidateStage>(
                tooltip: AppText.of(context, 'تغيير الحالة', 'Change status'),
                onSelected: onStageChanged,
                itemBuilder: (context) => _CandidateStage.values
                    .map(
                      (stage) => PopupMenuItem(
                        value: stage,
                        child: Text(_stageLabel(context, stage)),
                      ),
                    )
                    .toList(),
                child: _StageBadge(stage: candidate.stage),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoLabel(icon: Icons.email_outlined, label: candidate.email),
          const SizedBox(height: 7),
          _InfoLabel(
            icon: Icons.work_outline,
            label: candidate.jobTitle,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              TextButton.icon(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (context) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidate.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(candidate.role),
                          const SizedBox(height: 6),
                          Text(candidate.email),
                          const SizedBox(height: 6),
                          Text('${candidate.jobTitle} · '
                              '${_stageLabel(context, candidate.stage)}'),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            label: AppText.of(
                              context,
                              'تحديد موعد مقابلة',
                              'Schedule interview',
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              onSchedule();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                icon: const Icon(Icons.visibility_outlined, size: 17),
                label: Text(AppText.of(context, 'عرض الملف', 'View profile')),
              ),
              if (candidate.stage != _CandidateStage.interview)
                TextButton.icon(
                  onPressed: onSchedule,
                  icon: const Icon(Icons.event_outlined, size: 17),
                  label: Text(AppText.of(context, 'مقابلة', 'Interview')),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StageBadge extends StatelessWidget {
  final _CandidateStage stage;

  const _StageBadge({required this.stage});

  @override
  Widget build(BuildContext context) {
    final color = switch (stage) {
      _CandidateStage.newApplicant => AppColors.primaryViolet,
      _CandidateStage.underReview => AppColors.warning,
      _CandidateStage.interview => AppColors.success,
      _CandidateStage.hired => AppColors.success,
      _CandidateStage.rejected => AppColors.error,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        _stageLabel(context, stage),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InterviewsTab extends StatelessWidget {
  final List<_CompanyCandidate> candidates;
  final ValueChanged<_CompanyCandidate> onSchedule;
  final ValueChanged<_CompanyCandidate> onMarkDone;

  const _InterviewsTab({
    required this.candidates,
    required this.onSchedule,
    required this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    final ordered = [...candidates]..sort((a, b) =>
        (a.interviewAt ?? DateTime(2100))
            .compareTo(b.interviewAt ?? DateTime(2100)));
    return ordered.isEmpty
        ? _EmptyState(
            icon: Icons.event_busy_outlined,
            message: AppText.of(
              context,
              'لا توجد مقابلات مجدولة. يمكنك تحديد موعد من قائمة المتقدمين.',
              'No interviews scheduled. Schedule one from the applicants list.',
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: ordered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final candidate = ordered[index];
              final interviewAt = candidate.interviewAt;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceIndigo,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.event_available_outlined,
                          color: AppColors.accentPink,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            candidate.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: AppText.of(
                            context,
                            'تغيير الموعد',
                            'Change time',
                          ),
                          onPressed: () => onSchedule(candidate),
                          icon: const Icon(Icons.edit_calendar_outlined),
                        ),
                      ],
                    ),
                    Text(
                      '${candidate.role} · ${candidate.jobTitle}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      interviewAt == null
                          ? AppText.of(
                              context,
                              'لم يتم تحديد الوقت بعد',
                              'Time not set yet',
                            )
                          : '${_dateLabel(context, interviewAt)} · '
                              '${TimeOfDay.fromDateTime(interviewAt).format(context)}',
                      style: const TextStyle(
                        color: AppColors.accentPink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () => onMarkDone(candidate),
                        icon: const Icon(Icons.check_circle_outline, size: 17),
                        label: Text(AppText.of(
                            context, 'تمت المقابلة', 'Mark completed')),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

class _CompanyProfileTab extends StatelessWidget {
  final String companyName;
  final String email;
  final String phone;
  final String responsiblePerson;
  final String governorate;
  final VoidCallback onEdit;

  const _CompanyProfileTab({
    required this.companyName,
    required this.email,
    required this.phone,
    required this.responsiblePerson,
    required this.governorate,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.surfaceIndigoLight,
                child: Text(
                  companyName.isEmpty ? 'C' : companyName.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.accentPink,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                companyName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppText.of(context, 'ملف الشركة', 'Company profile'),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 17),
                label: Text(
                    AppText.of(context, 'تعديل المعلومات', 'Edit details')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _ProfileInfoTile(
          icon: Icons.email_outlined,
          label: AppText.of(context, 'البريد الإلكتروني', 'Email'),
          value: email,
        ),
        _ProfileInfoTile(
          icon: Icons.phone_outlined,
          label: AppText.of(context, 'رقم الهاتف', 'Phone'),
          value: phone,
        ),
        _ProfileInfoTile(
          icon: Icons.person_outline,
          label: AppText.of(context, 'مسؤول التوظيف', 'Hiring contact'),
          value: responsiblePerson,
        ),
        _ProfileInfoTile(
          icon: Icons.location_city_outlined,
          label: AppText.of(context, 'المحافظة', 'Governorate'),
          value: governorate,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceIndigoLight,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.accentPink),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppText.of(
                    context,
                    'هذه نسخة تجريبية. معلومات الشركة والوظائف والمتقدمون تُحفظ مؤقتًا على هذا الجهاز فقط.',
                    'This is a demo. Company details, jobs, and applicants are stored temporarily on this device only.',
                  ),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surfaceIndigo,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentPink, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyJobFormScreen extends StatefulWidget {
  const CompanyJobFormScreen({super.key});

  @override
  State<CompanyJobFormScreen> createState() => _CompanyJobFormScreenState();
}

class _CompanyJobFormScreenState extends State<CompanyJobFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _experienceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();
  String _type = 'Full-time';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? AppText.of(context, 'هذا الحقل مطلوب.', 'Required field.')
      : null;

  void _publish() {
    if (!_formKey.currentState!.validate()) return;
    final skills = _skillsController.text
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();
    Navigator.of(context).pop(
      CompanyJob(
        title: _titleController.text.trim(),
        location: _locationController.text.trim(),
        type: _type,
        salary: _salaryController.text.trim(),
        experience: _experienceController.text.trim(),
        description: _descriptionController.text.trim(),
        skills: skills,
        postedAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppText.of(context, 'إضافة وظيفة', 'Post a job')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(
              AppText.of(
                context,
                'أضف تفاصيل الوظيفة لمساعدة المرشحين على التقديم.',
                'Add job details to help candidates decide whether to apply.',
              ),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            _JobInput(
              controller: _titleController,
              label: AppText.of(context, 'المسمى الوظيفي', 'Job title'),
              icon: Icons.work_outline,
              validator: _required,
            ),
            const SizedBox(height: 14),
            _JobInput(
              controller: _locationController,
              label: AppText.of(
                  context, 'الموقع / المحافظة', 'Location / governorate'),
              icon: Icons.location_on_outlined,
              validator: _required,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _type,
              isExpanded: true,
              style: const TextStyle(color: AppColors.textDark),
              decoration: InputDecoration(
                labelText: AppText.of(
                  context,
                  'نوع الدوام',
                  'Employment type',
                ),
                prefixIcon: const Icon(Icons.schedule_outlined),
              ),
              items: [
                DropdownMenuItem(
                  value: 'Full-time',
                  child: Text(AppText.of(context, 'دوام كامل', 'Full-time')),
                ),
                DropdownMenuItem(
                  value: 'Part-time',
                  child: Text(AppText.of(context, 'دوام جزئي', 'Part-time')),
                ),
                DropdownMenuItem(
                  value: 'Contract',
                  child: Text(AppText.of(context, 'عقد', 'Contract')),
                ),
                DropdownMenuItem(
                  value: 'Remote',
                  child: Text(AppText.of(context, 'عن بُعد', 'Remote')),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _type = value);
              },
            ),
            const SizedBox(height: 14),
            _JobInput(
              controller: _salaryController,
              label: AppText.of(
                context,
                'الراتب (اختياري)',
                'Salary (optional)',
              ),
              icon: Icons.payments_outlined,
            ),
            const SizedBox(height: 14),
            _JobInput(
              controller: _experienceController,
              label: AppText.of(
                context,
                'الخبرة المطلوبة (اختياري)',
                'Experience (optional)',
              ),
              icon: Icons.workspace_premium_outlined,
            ),
            const SizedBox(height: 14),
            _JobInput(
              controller: _skillsController,
              label: AppText.of(
                context,
                'المهارات المطلوبة (افصل بينها بفاصلة)',
                'Required skills (comma separated)',
              ),
              icon: Icons.psychology_outlined,
            ),
            const SizedBox(height: 14),
            _JobInput(
              controller: _descriptionController,
              label: AppText.of(context, 'وصف الوظيفة', 'Job description'),
              icon: Icons.description_outlined,
              minLines: 4,
              maxLines: 6,
              validator: _required,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: AppText.of(context, 'نشر الوظيفة', 'Publish job'),
              icon: Icons.publish_outlined,
              onPressed: _publish,
            ),
          ],
        ),
      ),
    );
  }
}

class _JobInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final int minLines;
  final int maxLines;

  const _JobInput({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: minLines > 1,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionHeading({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceIndigo,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentPink.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: AppColors.accentPink),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textMuted, size: 38),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _stageLabel(BuildContext context, _CandidateStage stage) =>
    switch (stage) {
      _CandidateStage.newApplicant => AppText.of(context, 'جديد', 'New'),
      _CandidateStage.underReview =>
        AppText.of(context, 'قيد المراجعة', 'Under review'),
      _CandidateStage.interview => AppText.of(context, 'مقابلة', 'Interview'),
      _CandidateStage.hired => AppText.of(context, 'تم التوظيف', 'Hired'),
      _CandidateStage.rejected => AppText.of(context, 'مرفوض', 'Rejected'),
    };

String _dateLabel(BuildContext context, DateTime date) {
  return MaterialLocalizations.of(context).formatMediumDate(date);
}

String _timeAgo(DateTime date, bool isArabic) {
  final days = DateTime.now().difference(date).inDays;
  if (days <= 0) return isArabic ? 'اليوم' : 'today';
  if (days == 1) return isArabic ? 'منذ يوم' : '1 day ago';
  return isArabic ? 'منذ $days أيام' : '$days days ago';
}
