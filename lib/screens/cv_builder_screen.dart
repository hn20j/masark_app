import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_state.dart';
import 'home_screen.dart';

/// A guided profile builder for target roles, field, university major,
/// skills, and Iraq-only application preferences.
class CvBuilderScreen extends StatefulWidget {
  final bool fromOnboarding;
  const CvBuilderScreen({super.key, this.fromOnboarding = false});

  @override
  State<CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<CvBuilderScreen> {
  final _pageCtrl = PageController();
  int _step = 0;
  static const _totalSteps = 3;

  static const _categories = <(String, String, String)>[
    ('programming', 'البرمجة وتقنية المعلومات', 'Programming & IT'),
    ('medical', 'الطب والصحة', 'Medical & Healthcare'),
    ('engineering', 'الهندسة', 'Engineering'),
    ('business', 'الأعمال والإدارة', 'Business & Management'),
    ('education', 'التعليم', 'Education'),
    ('other', 'مجالات أخرى', 'Other fields'),
  ];
  static const _majors = <String, List<(String, String)>>{
    'programming': [
      ('علوم الحاسوب', 'Computer Science'),
      ('هندسة البرمجيات', 'Software Engineering'),
      ('نظم المعلومات', 'Information Systems'),
      ('تقنية المعلومات', 'Information Technology'),
      ('الأمن السيبراني', 'Cybersecurity'),
      ('علم البيانات والذكاء الاصطناعي', 'Data Science & AI'),
      ('هندسة الحاسوب', 'Computer Engineering'),
      ('شبكات الحاسوب', 'Computer Networks'),
    ],
    'medical': [
      ('الطب البشري', 'Medicine'),
      ('طب الأسنان', 'Dentistry'),
      ('الصيدلة', 'Pharmacy'),
      ('التمريض', 'Nursing'),
      ('التحاليل المرضية', 'Medical Laboratory Science'),
      ('الأشعة', 'Radiology'),
      ('العلاج الطبيعي', 'Physical Therapy'),
      ('الصحة العامة', 'Public Health'),
      ('الطب البيطري', 'Veterinary Medicine'),
    ],
    'engineering': [
      ('الهندسة المدنية', 'Civil Engineering'),
      ('الهندسة المعمارية', 'Architecture'),
      ('الهندسة الكهربائية', 'Electrical Engineering'),
      ('الهندسة الميكانيكية', 'Mechanical Engineering'),
      ('الهندسة الكيميائية', 'Chemical Engineering'),
      ('هندسة النفط', 'Petroleum Engineering'),
      ('هندسة الاتصالات', 'Telecommunications Engineering'),
      ('هندسة البيئة', 'Environmental Engineering'),
    ],
    'business': [
      ('إدارة الأعمال', 'Business Administration'),
      ('المحاسبة', 'Accounting'),
      ('الاقتصاد', 'Economics'),
      ('التمويل والمصارف', 'Finance & Banking'),
      ('التسويق', 'Marketing'),
      ('إدارة الموارد البشرية', 'Human Resources Management'),
      ('إدارة سلاسل الإمداد', 'Supply Chain Management'),
    ],
    'education': [
      ('اللغة العربية', 'Arabic Language'),
      ('اللغة الإنجليزية', 'English Language'),
      ('الرياضيات', 'Mathematics'),
      ('الفيزياء', 'Physics'),
      ('الكيمياء', 'Chemistry'),
      ('الأحياء', 'Biology'),
      ('التربية', 'Education'),
      ('الإرشاد النفسي', 'Counseling Psychology'),
    ],
    'other': [
      ('القانون', 'Law'),
      ('الإعلام', 'Media & Communication'),
      ('التصميم الجرافيكي', 'Graphic Design'),
      ('العلوم السياسية', 'Political Science'),
      ('الزراعة', 'Agriculture'),
      ('السياحة والآثار', 'Tourism & Archaeology'),
    ],
  };
  static const _roleOptions = <String, List<(String, String)>>{
    'programming': [
      ('مطور برمجيات', 'Software Developer'),
      ('مطور تطبيقات موبايل', 'Mobile App Developer'),
      ('مطور واجهات أمامية', 'Frontend Developer'),
      ('مطور خلفية', 'Backend Developer'),
      ('مهندس بيانات', 'Data Engineer'),
      ('محلل بيانات', 'Data Analyst'),
      ('مهندس شبكات', 'Network Engineer'),
      ('مختص أمن سيبراني', 'Cybersecurity Specialist'),
      ('مصمم UI/UX', 'UI/UX Designer'),
      ('مختبر برمجيات', 'Software Tester'),
      ('مسؤول دعم فني', 'IT Support Specialist'),
    ],
    'medical': [
      ('طبيب', 'Physician'),
      ('طبيب أسنان', 'Dentist'),
      ('صيدلي', 'Pharmacist'),
      ('ممرض', 'Nurse'),
      ('محلل مختبر', 'Laboratory Technician'),
      ('فني أشعة', 'Radiology Technician'),
      ('أخصائي علاج طبيعي', 'Physical Therapist'),
      ('مسؤول صحة عامة', 'Public Health Officer'),
    ],
    'engineering': [
      ('مهندس مدني', 'Civil Engineer'),
      ('مهندس معماري', 'Architect'),
      ('مهندس كهرباء', 'Electrical Engineer'),
      ('مهندس ميكانيك', 'Mechanical Engineer'),
      ('مهندس نفط', 'Petroleum Engineer'),
      ('مهندس اتصالات', 'Telecommunications Engineer'),
    ],
    'business': [
      ('محاسب', 'Accountant'),
      ('مدير مشاريع', 'Project Manager'),
      ('أخصائي تسويق', 'Marketing Specialist'),
      ('مندوب مبيعات', 'Sales Representative'),
      ('محلل أعمال', 'Business Analyst'),
      ('أخصائي موارد بشرية', 'Human Resources Specialist'),
      ('خدمة عملاء', 'Customer Service Representative'),
    ],
    'education': [
      ('معلم', 'Teacher'),
      ('مدرس لغة إنجليزية', 'English Teacher'),
      ('مدرس رياضيات', 'Math Teacher'),
      ('مرشد تربوي', 'School Counselor'),
      ('محاضر جامعي', 'University Lecturer'),
    ],
    'other': [
      ('محامٍ', 'Lawyer'),
      ('صحفي', 'Journalist'),
      ('مصمم جرافيك', 'Graphic Designer'),
      ('مترجم', 'Translator'),
      ('باحث', 'Researcher'),
    ],
  };
  static const _skillOptions = <String, List<String>>{
    'programming': [
      'Flutter',
      'Dart',
      'Java',
      'JavaScript',
      'TypeScript',
      'React',
      'Python',
      'C#',
      'C++',
      'HTML',
      'CSS',
      'SQL',
      'Firebase',
      'Git',
      'REST APIs',
      'Linux',
      'Cybersecurity',
      'Data Analysis',
      'Excel',
    ],
    'medical': [
      'Patient Care',
      'Clinical Assessment',
      'First Aid',
      'CPR',
      'Medical Records',
      'Phlebotomy',
      'Laboratory Testing',
      'Patient Safety',
      'Medication Administration',
      'Medical Imaging',
      'Infection Control',
    ],
    'engineering': [
      'AutoCAD',
      'Revit',
      'MATLAB',
      'Project Planning',
      'Quality Control',
      'Structural Analysis',
      'Electrical Design',
      'Safety Management',
      'Technical Drawing',
      'Problem Solving',
    ],
    'business': [
      'Accounting',
      'Microsoft Excel',
      'Project Management',
      'Sales',
      'Customer Service',
      'Digital Marketing',
      'Negotiation',
      'Leadership',
      'Power BI',
      'Financial Analysis',
      'Communication',
    ],
    'education': [
      'Lesson Planning',
      'Classroom Management',
      'Curriculum Design',
      'Student Assessment',
      'Tutoring',
      'Communication',
      'Public Speaking',
    ],
    'other': [
      'Graphic Design',
      'Adobe Photoshop',
      'Writing',
      'Translation',
      'Research',
      'Social Media',
      'Communication',
      'Time Management',
    ],
  };

  final _roleController = TextEditingController();
  final _skillController = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final Set<String> _roles = {};
  final Set<String> _skills = {};
  String _category = 'programming';
  String? _major;
  bool _remoteOk = true;
  bool _loadingPreferences = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPreferences());
  }

  Future<void> _loadPreferences() async {
    final state = context.read<AppState>();
    await state.restoreProfileDetails();
    if (!mounted) return;
    final user = state.currentUser;
    if (user != null) {
      _roles.addAll(user.workPreferences);
      _skills.addAll(user.skills);
      _category = _majors.containsKey(user.careerCategory)
          ? user.careerCategory!
          : 'programming';
      _major =
          _majors[_category]!.any((item) => item.$1 == user.universityMajor)
              ? user.universityMajor
              : null;
      _yearsCtrl.text = user.yearsExperience ?? '';
      _remoteOk = user.remoteOk;
    }
    setState(() => _loadingPreferences = false);
  }

  @override
  void dispose() {
    _roleController.dispose();
    _skillController.dispose();
    _yearsCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    } else {
      final state = context.read<AppState>();
      try {
        await state.saveApplicationPreferences(
          targetRoles: _roles.toList(),
          skills: _skills.toList(),
          careerCategory: _category,
          universityMajor: _major,
          yearsExperience: _yearsCtrl.text.trim(),
          remoteOk: _remoteOk,
        );
        if (!mounted) return;
        await state.completeProfile();
        if (!mounted) return;
        if (widget.fromOnboarding) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else {
          Navigator.of(context).pop();
        }
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppText.of(
              context,
              'تعذر حفظ التفضيلات. تحقق من اتصالك وحاول مجددًا.',
              'Could not save preferences. Check your connection and try again.',
            )),
          ),
        );
      }
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.previousPage(
          duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading:
            IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _back),
        title: Text(
            AppText.of(context, 'إكمال الملف الشخصي', 'Complete your profile')),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                children: List.generate(_totalSteps, (i) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                          end: i == _totalSteps - 1 ? 0 : 6),
                      height: 5,
                      decoration: BoxDecoration(
                        color: i <= _step
                            ? AppColors.accentPink
                            : AppColors.surfaceIndigoLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: _loadingPreferences
                  ? const Center(child: CircularProgressIndicator())
                  : PageView(
                      controller: _pageCtrl,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _stepCareer(),
                        _stepSkills(),
                        _stepPreferences(),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: PrimaryButton(
                label: _step == _totalSteps - 1
                    ? AppText.of(
                        context, 'إنهاء وعرض الفرص', 'Finish and view jobs')
                    : AppText.of(context, 'التالي', 'Next'),
                onPressed: _next,
                loading: _loadingPreferences,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wrap(String title, String subtitle, Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _stepCareer() {
    final customOrOtherCategoryRoles = _roles.where(
        (role) => !_roleOptions[_category]!.any((option) => option.$1 == role));
    return _wrap(
      AppText.of(context, 'مجالك وتخصصك', 'Your field and major'),
      AppText.of(context, 'اختر المجال لتصفية التخصصات والوظائف المناسبة لك.',
          'Choose a field to filter relevant majors and job roles.'),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _category,
            isExpanded: true,
            style: const TextStyle(color: AppColors.textDark),
            decoration: InputDecoration(
              labelText: AppText.of(context, 'المجال', 'Field'),
            ),
            items: _categories
                .map((item) => DropdownMenuItem(
                      value: item.$1,
                      child: Text(
                        AppText.of(context, item.$2, item.$3),
                        style: const TextStyle(color: AppColors.textDark),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _category = value;
                _major = null;
              });
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _major,
            isExpanded: true,
            style: const TextStyle(color: AppColors.textDark),
            decoration: InputDecoration(
              labelText: AppText.of(context, 'التخصص الجامعي (اختياري)',
                  'University major (optional)'),
            ),
            items: _majors[_category]!
                .map((item) => DropdownMenuItem(
                      value: item.$1,
                      child: Text(
                        AppText.of(context, item.$1, item.$2),
                        style: const TextStyle(color: AppColors.textDark),
                      ),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _major = value),
          ),
          const SizedBox(height: 18),
          Text(
            AppText.of(context, 'الوظائف المستهدفة', 'Target job roles'),
            style: const TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _roleOptions[_category]!.map((role) {
              final selected = _roles.contains(role.$1);
              return FilterChip(
                label: Text(AppText.of(context, role.$1, role.$2)),
                selected: selected,
                onSelected: (value) =>
                    _changeSelection(_roles, role.$1, value),
                selectedColor: AppColors.surfaceIndigoLight,
                backgroundColor: AppColors.surfaceIndigoLight,
                labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textSecondary),
                checkmarkColor: Colors.white,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _roleController,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.textDark),
                  onSubmitted: (_) => _addRole(),
                  decoration: InputDecoration(
                    hintText: AppText.of(
                        context, 'أضف مسمى وظيفيًا', 'Add a custom job role'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: AppText.of(context, 'إضافة وظيفة', 'Add role'),
                onPressed: _addRole,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          if (customOrOtherCategoryRoles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: customOrOtherCategoryRoles
                    .map((role) => InputChip(
                          label: Text(_roleLabel(role)),
                          onDeleted: () => setState(() => _roles.remove(role)),
                        ))
                    .toList(),
              ),
            ),
          const SizedBox(height: 18),
          Text(
            AppText.of(context, 'سنوات الخبرة', 'Years of experience'),
            style: const TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _yearsCtrl,
            maxLength: 40,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: AppText.of(context, 'مثال: 3', 'Example: 3'),
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(String role) {
    for (final roles in _roleOptions.values) {
      for (final option in roles) {
        if (option.$1 == role) return AppText.of(context, option.$1, option.$2);
      }
    }
    return role;
  }

  void _changeSelection(Set<String> values, String value, bool selected) {
    if (!selected) {
      setState(() => values.remove(value));
      return;
    }
    if (values.contains(value)) return;
    if (values.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppText.of(
            context,
            'يمكنك اختيار 20 عنصرًا كحد أقصى.',
            'You can select up to 20 items.',
          )),
        ),
      );
      return;
    }
    setState(() => values.add(value));
  }

  void _addRole() {
    final role = _roleController.text.trim();
    if (role.isEmpty || _roles.contains(role)) return;
    if (_roles.length >= 20) {
      _showSelectionLimit();
      return;
    }
    setState(() {
      _roles.add(role);
      _roleController.clear();
    });
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty || _skills.contains(skill)) return;
    if (_skills.length >= 20) {
      _showSelectionLimit();
      return;
    }
    setState(() {
      _skills.add(skill);
      _skillController.clear();
    });
  }

  void _showSelectionLimit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppText.of(
          context,
          'يمكنك اختيار 20 عنصرًا كحد أقصى.',
          'You can select up to 20 items.',
        )),
      ),
    );
  }

  Widget _stepSkills() {
    final skillsFromOtherCategories =
        _skills.where((skill) => !_skillOptions[_category]!.contains(skill));
    return _wrap(
      AppText.of(context, 'اختر مهاراتك', 'Choose your skills'),
      AppText.of(
          context,
          'اختر كل المهارات التي تنطبق عليك (يمكن اختيار أكثر من واحدة)',
          'Choose all skills that apply (you can select more than one).'),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.of(context, 'المهارات المقترحة', 'Suggested skills'),
            style: const TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: _skillOptions[_category]!.map((skill) {
              final selected = _skills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: selected,
                onSelected: (value) =>
                    _changeSelection(_skills, skill, value),
                selectedColor: AppColors.surfaceIndigoLight,
                backgroundColor: AppColors.surfaceIndigoLight,
                labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textSecondary),
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  side: BorderSide.none,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            AppText.of(context, 'أضف مهارة أخرى', 'Add another skill'),
            style: const TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillController,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.textDark),
                  onSubmitted: (_) => _addSkill(),
                  decoration: InputDecoration(
                    hintText:
                        AppText.of(context, 'اكتب مهارة', 'Enter a skill'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: AppText.of(context, 'إضافة مهارة', 'Add skill'),
                onPressed: _addSkill,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          if (skillsFromOtherCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: skillsFromOtherCategories
                    .map((skill) => InputChip(
                          label: Text(skill),
                          onDeleted: () =>
                              setState(() => _skills.remove(skill)),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stepPreferences() {
    return _wrap(
      AppText.of(context, 'أين تريد أن يقدم الوكيل عنك؟',
          'Where should the agent apply for you?'),
      AppText.of(
          context,
          'سيبحث الوكيل عن الشركات ويقدم سيرتك تلقائيًا في هذه الدولة',
          'The agent will find companies and submit your CV in this country.'),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: AppText.of(context, 'الدولة', 'Country'),
              prefixIcon: const Icon(Icons.flag_outlined),
            ),
            child: Text(
              AppText.of(context, 'العراق', 'Iraq'),
              style: const TextStyle(color: AppColors.textDark),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceIndigoLight,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: SwitchListTile(
              value: _remoteOk,
              onChanged: (v) => setState(() => _remoteOk = v),
              activeThumbColor: AppColors.accentPink,
              title: Text(
                  AppText.of(context, 'أوافق أيضًا على الوظائف عن بُعد',
                      'I am also open to remote jobs'),
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
