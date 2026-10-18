import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../widgets/language_selector.dart';
import 'company_login_screen.dart';
import 'company_signup_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

enum _AccountType { employee, company }

class SignupTypeScreen extends StatefulWidget {
  final bool signInMode;

  const SignupTypeScreen({super.key, this.signInMode = false});

  @override
  State<SignupTypeScreen> createState() => _SignupTypeScreenState();
}

class _SignupTypeScreenState extends State<SignupTypeScreen> {
  _AccountType? _selectedType;

  void _continueAsEmployee() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            widget.signInMode ? const LoginScreen() : const SignupScreen(),
      ),
    );
  }

  void _continueAsCompany() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => widget.signInMode
            ? const CompanyLoginScreen()
            : const CompanySignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: AlignmentDirectional.centerEnd,
                child: LanguageSelector(),
              ),
              const SizedBox(height: 42),
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceIndigoLight,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(
                  widget.signInMode
                      ? Icons.login_outlined
                      : Icons.person_add_alt_1_outlined,
                  color: AppColors.accentPink,
                  size: 30,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppText.of(
                  context,
                  widget.signInMode ? 'تسجيل الدخول' : 'إنشاء حساب جديد',
                  widget.signInMode ? 'Sign in' : 'Create a new account',
                ),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppText.of(
                  context,
                  widget.signInMode
                      ? 'اختر نوع الحساب لتسجيل الدخول'
                      : 'اختر نوع الحساب للمتابعة',
                  widget.signInMode
                      ? 'Choose your account type to sign in'
                      : 'Choose your account type to continue',
                ),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              _AccountTypeCard(
                title: AppText.of(context, 'موظف', 'Employee'),
                description: AppText.of(
                  context,
                  widget.signInMode
                      ? 'تسجيل الدخول إلى حساب الموظف'
                      : 'أبحث عن فرصة عمل مناسبة',
                  widget.signInMode
                      ? 'Sign in to your employee account'
                      : 'I’m looking for the right job opportunity',
                ),
                icon: Icons.person_search_outlined,
                selected: _selectedType == _AccountType.employee,
                onTap: () =>
                    setState(() => _selectedType = _AccountType.employee),
              ),
              const SizedBox(height: 16),
              _AccountTypeCard(
                title: AppText.of(context, 'شركة', 'Company'),
                description: AppText.of(
                  context,
                  widget.signInMode
                      ? 'تسجيل الدخول إلى حساب الشركة'
                      : 'أبحث عن موظفين لفريقي',
                  widget.signInMode
                      ? 'Sign in to your company account'
                      : 'I’m looking for people to join my team',
                ),
                icon: Icons.business_outlined,
                selected: _selectedType == _AccountType.company,
                onTap: () =>
                    setState(() => _selectedType = _AccountType.company),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: AppText.of(context, 'متابعة', 'Continue'),
                onPressed: switch (_selectedType) {
                  _AccountType.employee => _continueAsEmployee,
                  _AccountType.company => _continueAsCompany,
                  null => null,
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(AppText.of(context, 'رجوع', 'Back')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? AppColors.accentPink : Colors.white.withValues(alpha: 0.12);

    return Material(
      color: selected
          ? AppColors.surfaceIndigoLight
          : AppColors.surfaceIndigo.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: borderColor, width: selected ? 1.6 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentPink.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(icon, color: AppColors.accentPink, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? AppColors.accentPink : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
