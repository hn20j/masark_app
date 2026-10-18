import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_text.dart';
import '../theme/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_error_message.dart';
import 'company_dashboard_screen.dart';

class CompanySignupScreen extends StatefulWidget {
  const CompanySignupScreen({super.key});

  @override
  State<CompanySignupScreen> createState() => _CompanySignupScreenState();
}

class _CompanySignupScreenState extends State<CompanySignupScreen> {
  static const _callingCodes = <(String, String, String)>[
    ('+964', 'العراق', 'Iraq'),
    ('+962', 'الأردن', 'Jordan'),
    ('+971', 'الإمارات', 'UAE'),
    ('+966', 'السعودية', 'Saudi Arabia'),
    ('+965', 'الكويت', 'Kuwait'),
    ('+90', 'تركيا', 'Turkey'),
  ];

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

  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _responsiblePersonController = TextEditingController();
  String _callingCode = '+964';
  String? _governorate;
  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _responsiblePersonController.dispose();
    super.dispose();
  }

  String? _requiredValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppText.of(context, 'هذا الحقل مطلوب.', 'This field is required.');
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AppState>().signUpCompany(
            companyName: _companyNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: '$_callingCode ${_phoneController.text.trim()}',
            responsiblePerson: _responsiblePersonController.text.trim(),
            governorate: _governorate!,
          );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CompanyDashboardScreen(
            companyName: _companyNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: '$_callingCode ${_phoneController.text.trim()}',
            responsiblePerson: _responsiblePersonController.text.trim(),
            governorate: _governorate!,
          ),
        ),
      );
    } on FirebaseException catch (error, stackTrace) {
      logAuthenticationFailure(error, stackTrace);
      if (mounted) {
        _showMessage(firebaseAuthErrorMessage(context, error, signingUp: true));
      }
    } catch (error, stackTrace) {
      logAuthenticationFailure(error, stackTrace);
      if (mounted) {
        _showMessage(
          AppText.of(
            context,
            'تعذر إنشاء الحساب. حاول مجددًا.',
            'Could not create the account. Please try again.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppText.of(context, 'حساب شركة', 'Company account')),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceIndigoLight,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: AppColors.accentPink,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppText.of(
                    context, 'إنشاء حساب الشركة', 'Create a company account'),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppText.of(
                  context,
                  'أدخل معلومات الشركة والشخص المسؤول عن التوظيف',
                  'Enter your company and hiring contact details',
                ),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _companyNameController,
                maxLength: 120,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: AppColors.textDark),
                decoration: InputDecoration(
                  labelText: AppText.of(context, 'اسم الشركة', 'Company name'),
                  prefixIcon: const Icon(Icons.business_outlined),
                ),
                validator: _requiredValue,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                maxLength: 254,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textDark),
                decoration: InputDecoration(
                  labelText: AppText.of(context, 'البريد الإلكتروني', 'Email'),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return _requiredValue(value);
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                    return AppText.of(
                      context,
                      'أدخل بريدًا إلكترونيًا صالحًا.',
                      'Enter a valid email address.',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: AppColors.textDark),
                decoration: InputDecoration(
                  labelText: AppText.of(context, 'كلمة المرور', 'Password'),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.length < 6
                    ? AppText.of(
                        context,
                        'استخدم 6 أحرف على الأقل.',
                        'Use at least 6 characters.',
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 142,
                    child: DropdownButtonFormField<String>(
                      initialValue: _callingCode,
                      isExpanded: true,
                      style: const TextStyle(color: AppColors.textDark),
                      decoration: InputDecoration(
                        labelText:
                            AppText.of(context, 'رمز الدولة', 'Country code'),
                      ),
                      items: _callingCodes
                          .map(
                            (country) => DropdownMenuItem(
                              value: country.$1,
                              child: Text(
                                '${country.$1} ${isArabic ? country.$2 : country.$3}',
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: AppColors.textDark),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _callingCode = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.textDark),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                      decoration: InputDecoration(
                        labelText:
                            AppText.of(context, 'رقم الهاتف', 'Phone number'),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      validator: (value) {
                        final digits = value?.trim() ?? '';
                        if (digits.isEmpty) return _requiredValue(value);
                        if (digits.length < 7) {
                          return AppText.of(
                            context,
                            'أدخل رقم هاتف صالحًا.',
                            'Enter a valid phone number.',
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _responsiblePersonController,
                maxLength: 120,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: AppColors.textDark),
                decoration: InputDecoration(
                  labelText: AppText.of(
                    context,
                    'اسم الشخص المسؤول عن التوظيف',
                    'Hiring contact name',
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: _requiredValue,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _governorate,
                isExpanded: true,
                style: const TextStyle(color: AppColors.textDark),
                decoration: InputDecoration(
                  labelText: AppText.of(context, 'المحافظة', 'Governorate'),
                  prefixIcon: const Icon(Icons.location_city_outlined),
                ),
                items: _governorates
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.$1,
                        child: Text(
                          isArabic ? item.$2 : item.$3,
                          style: const TextStyle(color: AppColors.textDark),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _governorate = value),
                validator: (value) => value == null
                    ? AppText.of(
                        context,
                        'اختر المحافظة.',
                        'Select a governorate.',
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              FormField<bool>(
                initialValue: _acceptedTerms,
                validator: (value) => value != true
                    ? AppText.of(
                        context,
                        'يجب الموافقة على شروط الاستخدام للمتابعة.',
                        'Accept the Terms of Use to continue.',
                      )
                    : null,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() => _acceptedTerms = value ?? false);
                        field.didChange(_acceptedTerms);
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.accentPink,
                      title: Text(
                        AppText.of(
                          context,
                          'أوافق على شروط الاستخدام وسياسة الخصوصية',
                          'I agree to the Terms of Use and Privacy Policy',
                        ),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 12),
                        child: Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: AppText.of(
                    context, 'إنشاء حساب الشركة', 'Create company account'),
                onPressed: _submit,
                loading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
