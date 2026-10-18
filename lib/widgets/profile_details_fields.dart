import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ProfileDetailsValue {
  final DateTime birthdate;
  final String governorate;
  final String governorateRegion;
  final String academicAchievement;
  final List<String> workPreferences;
  final String workLocation;

  const ProfileDetailsValue({
    required this.birthdate,
    required this.governorate,
    required this.governorateRegion,
    required this.academicAchievement,
    required this.workPreferences,
    required this.workLocation,
  });
}

class ProfileDetailsFields extends StatefulWidget {
  final AppUser? initialUser;

  const ProfileDetailsFields({super.key, this.initialUser});

  @override
  State<ProfileDetailsFields> createState() => ProfileDetailsFieldsState();
}

class ProfileDetailsFieldsState extends State<ProfileDetailsFields> {
  static const _governorates = <(String, String, String)>[
    ('Baghdad', 'بغداد', 'Baghdad'),
    ('Basra', 'البصرة', 'Basra'),
    ('Maysan', 'ميسان', 'Maysan'),
    ('Dhi Qar', 'ذي قار', 'Dhi Qar'),
    ('Muthanna', 'المثنى', 'Muthanna'),
    ('Qadisiyyah', 'القادسية', 'Qadisiyyah'),
    ('Babil', 'بابل', 'Babil'),
    ('Karbala', 'كربلاء', 'Karbala'),
    ('Najaf', 'النجف', 'Najaf'),
    ('Wasit', 'واسط', 'Wasit'),
    ('Diyala', 'ديالى', 'Diyala'),
    ('Kirkuk', 'كركوك', 'Kirkuk'),
    ('Saladin', 'صلاح الدين', 'Saladin'),
    ('Nineveh', 'نينوى', 'Nineveh'),
    ('Anbar', 'الأنبار', 'Anbar'),
    ('Erbil', 'أربيل', 'Erbil'),
    ('Duhok', 'دهوك', 'Duhok'),
    ('Sulaymaniyah', 'السليمانية', 'Sulaymaniyah'),
    ('Halabja', 'حلبجة', 'Halabja'),
  ];

  final _regionController = TextEditingController();
  final _achievementController = TextEditingController();
  final _workLocationController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _jobController = TextEditingController();
  final _jobsFieldKey = GlobalKey<FormFieldState<List<String>>>();
  DateTime? _birthdate;
  String? _governorate;
  late List<String> _workPreferences;

  ProfileDetailsValue get value => ProfileDetailsValue(
        birthdate: _birthdate!,
        governorate: _governorate!,
        governorateRegion: _regionController.text.trim(),
        academicAchievement: _achievementController.text.trim(),
        workPreferences: List.unmodifiable(_workPreferences),
        workLocation: _workLocationController.text.trim(),
      );

  @override
  void initState() {
    super.initState();
    final user = widget.initialUser;
    _birthdate = user?.birthdate;
    _birthdateController.text =
        _birthdate == null ? '' : _dateLabel(_birthdate!);
    _governorate = user?.governorate;
    _regionController.text = user?.governorateRegion ?? '';
    _achievementController.text = user?.academicAchievement ?? '';
    _workLocationController.text = user?.workLocation ?? '';
    _workPreferences = List.of(user?.workPreferences ?? []);
  }

  @override
  void dispose() {
    _regionController.dispose();
    _achievementController.dispose();
    _workLocationController.dispose();
    _birthdateController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  void _addJob() {
    final job = _jobController.text.trim();
    if (job.isEmpty || _workPreferences.contains(job)) return;
    if (_workPreferences.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppText.of(
            context,
            'يمكنك إضافة 20 وظيفة مفضلة كحد أقصى.',
            'You can add up to 20 job preferences.',
          )),
        ),
      );
      return;
    }
    setState(() {
      _workPreferences.add(job);
      _jobController.clear();
    });
    _jobsFieldKey.currentState?.didChange(_workPreferences);
  }

  String _dateLabel(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          readOnly: true,
          style: const TextStyle(color: AppColors.textDark),
          decoration: InputDecoration(
            labelText: AppText.of(context, 'تاريخ الميلاد', 'Birthdate'),
            prefixIcon: const Icon(Icons.cake_outlined),
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
          controller: _birthdateController,
          onTap: () async {
            final today = DateTime.now();
            final selected = await showDatePicker(
              context: context,
              initialDate: _birthdate ??
                  DateTime(today.year - 18, today.month, today.day),
              firstDate: DateTime(1900),
              lastDate: today,
            );
            if (selected != null) {
              setState(() => _birthdate = selected);
            }
          },
          validator: (_) => _birthdate == null
              ? AppText.of(
                  context, 'اختر تاريخ ميلادك.', 'Select your birthdate.')
              : null,
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _governorate,
          isExpanded: true,
          style: const TextStyle(color: AppColors.textDark),
          decoration: InputDecoration(
            labelText: AppText.of(context, 'المحافظة', 'Governorate'),
            prefixIcon: const Icon(Icons.location_city_outlined),
          ),
          items: _governorates
              .map((item) => DropdownMenuItem(
                    value: item.$1,
                    child: Text(
                      isArabic ? item.$2 : item.$3,
                      style: const TextStyle(color: AppColors.textDark),
                    ),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _governorate = value),
          validator: (value) => value == null
              ? AppText.of(context, 'اختر المحافظة.', 'Select a governorate.')
              : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _regionController,
          maxLength: 150,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: AppColors.textDark),
          decoration: InputDecoration(
            labelText: AppText.of(
                context, 'المنطقة داخل المحافظة', 'Region within governorate'),
            prefixIcon: const Icon(Icons.place_outlined),
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? AppText.of(context, 'أدخل منطقتك.', 'Enter your region.')
              : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _achievementController,
          maxLength: 150,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(color: AppColors.textDark),
          decoration: InputDecoration(
            labelText:
                AppText.of(context, 'التحصيل الدراسي', 'Academic achievement'),
            prefixIcon: const Icon(Icons.school_outlined),
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? AppText.of(
                  context, 'أدخل تحصيلك الدراسي.', 'Enter your education.')
              : null,
        ),
        const SizedBox(height: 14),
        FormField<List<String>>(
          key: _jobsFieldKey,
          initialValue: _workPreferences,
          validator: (value) => value == null || value.isEmpty
              ? AppText.of(context, 'أضف تفضيل عمل واحدًا على الأقل.',
                  'Add at least one job preference.')
              : null,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppText.of(context, 'الوظائف المفضلة', 'Job preferences'),
                style: const TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _jobController,
                      maxLength: 100,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: AppColors.textDark),
                      onSubmitted: (_) => _addJob(),
                      decoration: InputDecoration(
                        hintText: AppText.of(
                            context, 'مثال: محاسب', 'Example: Accountant'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: AppText.of(context, 'إضافة وظيفة', 'Add job'),
                    onPressed: _addJob,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              if (_workPreferences.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _workPreferences
                        .map((job) => InputChip(
                              label: Text(job),
                              onDeleted: () {
                                setState(() => _workPreferences.remove(job));
                                field.didChange(_workPreferences);
                              },
                            ))
                        .toList(),
                  ),
                ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(field.errorText!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _workLocationController,
          maxLength: 150,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: AppColors.textDark),
          decoration: InputDecoration(
            labelText:
                AppText.of(context, 'مكان العمل المفضل', 'Work location'),
            prefixIcon: const Icon(Icons.work_outline),
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? AppText.of(
                  context, 'أدخل مكان العمل.', 'Enter a work location.')
              : null,
        ),
      ],
    );
  }
}
