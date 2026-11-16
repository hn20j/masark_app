import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_text.dart';
import '../theme/app_state.dart';
import '../theme/app_theme.dart';
import 'company_dashboard_screen.dart';
import 'company_signup_screen.dart';

class CompanyLoginScreen extends StatefulWidget {
  const CompanyLoginScreen({super.key});

  @override
  State<CompanyLoginScreen> createState() => _CompanyLoginScreenState();
}

class _CompanyLoginScreenState extends State<CompanyLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final state = context.read<AppState>();
      await state.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        homeCountry: AppText.of(context, 'العراق', 'Iraq'),
        accountType: 'company',
      );
      if (!mounted) return;

      final company = state.currentUser!;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => CompanyDashboardScreen(
            companyName: company.name,
            email: company.companyContactEmail ?? company.email,
            phone: company.phone ?? '',
            responsiblePerson: company.responsiblePerson ?? '',
            governorate: company.governorate ?? '',
          ),
        ),
        (route) => false,
      );
    } catch (error) {
      if (mounted) {
        _showMessage(
          '${AppText.of(context, 'تعذر تسجيل الدخول.', 'Could not sign in.')} '
          '${AppState.errorMessage(error)}',
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
    return Scaffold(
      backgroundColor: context.appPalette.background,
      appBar: AppBar(
        title: Text(AppText.of(context, 'دخول الشركة', 'Company sign in')),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.appPalette.surfaceIndigoLight,
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
                AppText.of(context, 'تسجيل دخول الشركة', 'Company sign in'),
                style: TextStyle(
                  color: context.appPalette.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppText.of(
                  context,
                  'أدخل البريد الإلكتروني وكلمة المرور لحساب شركتك',
                  'Enter the email and password for your company account',
                ),
                style: TextStyle(
                  color: context.appPalette.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textDark),
                decoration: InputDecoration(
                  labelText: AppText.of(context, 'البريد الإلكتروني', 'Email'),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) {
                    return AppText.of(
                      context,
                      'هذا الحقل مطلوب.',
                      'This field is required.',
                    );
                  }
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
                validator: (value) => value == null || value.isEmpty
                    ? AppText.of(
                        context,
                        'هذا الحقل مطلوب.',
                        'This field is required.',
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: AppText.of(context, 'تسجيل الدخول', 'Sign in'),
                onPressed: _signIn,
                loading: _loading,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CompanySignupScreen(),
                  ),
                ),
                child: Text(
                  AppText.of(
                    context,
                    'ليس لديك حساب شركة؟ أنشئ حسابًا',
                    'New to Masarak? Create a company account',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
