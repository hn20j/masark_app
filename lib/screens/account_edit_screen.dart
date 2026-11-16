import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_text.dart';
import '../theme/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/profile_details_fields.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileFieldsKey = GlobalKey<ProfileDetailsFieldsState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  bool _obscurePasswords = true;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppState>().currentUser;
    _nameController.text = profile?.name ?? '';
    _emailController.text = profile?.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final state = context.read<AppState>();
    final user = state.currentUser;
    if (user == null) {
      _showMessage(AppText.of(
          context, 'يرجى تسجيل الدخول أولاً.', 'Please sign in first.'));
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final profileDetails = _profileFieldsKey.currentState!.value;
    final emailChanged = email != user.email;
    final passwordChanged = _newPasswordController.text.isNotEmpty;
    final needsReauthentication = emailChanged || passwordChanged;
    if (needsReauthentication && _currentPasswordController.text.isEmpty) {
      _showMessage(AppText.of(context, 'أدخل كلمة المرور الحالية للمتابعة.',
          'Enter your current password to continue.'));
      return;
    }

    setState(() => _loading = true);
    try {
      final emailChangePending = await state.updateAccount(
        name: name,
        email: email,
        currentPassword: _currentPasswordController.text,
        newPassword: passwordChanged ? _newPasswordController.text : null,
      );
      if (!mounted) return;
      await state.updateProfileDetails(
        birthdate: profileDetails.birthdate,
        governorate: profileDetails.governorate,
        governorateRegion: profileDetails.governorateRegion,
        academicAchievement: profileDetails.academicAchievement,
        workPreferences: profileDetails.workPreferences,
        workLocation: profileDetails.workLocation,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            emailChangePending
                ? AppText.of(
                    context,
                    'أرسلنا رابط التحقق إلى البريد الجديد؛ سيبقى البريد الحالي فعالًا حتى تأكيده.',
                    'A verification link was sent to the new email. Your current email stays active until it is verified.',
                  )
                : AppText.of(context, 'تم تحديث بيانات الحساب.',
                    'Account details updated.'),
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        _showMessage(AppState.errorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final newPassword = _newPasswordController.text;
    final currentUser = context.watch<AppState>().currentUser;
    final hasEmailAccount = currentUser?.email.isNotEmpty ?? false;
    return Scaffold(
      backgroundColor: context.appPalette.background,
      appBar: AppBar(
        title: Text(AppText.of(context, 'إعدادات الحساب', 'Account settings')),
      ),
      body: SafeArea(
        top: false,
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
                  bodyLarge: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.black),
                ),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              children: [
                _sectionTitle(
                    context,
                    AppText.of(
                        context, 'المعلومات الشخصية', 'Personal information')),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.textDark),
                  decoration: InputDecoration(
                    labelText: AppText.of(context, 'الاسم الكامل', 'Full name'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? AppText.of(context, 'أدخل اسمك.', 'Enter your name.')
                      : null,
                ),
                const SizedBox(height: 14),
                ProfileDetailsFields(
                  key: _profileFieldsKey,
                  initialUser: context.read<AppState>().currentUser,
                ),
                const SizedBox(height: 14),
                if (hasEmailAccount)
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                      labelText: AppText.of(
                          context, 'البريد الإلكتروني', 'Email address'),
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),
                    validator: (value) =>
                        value == null || !value.trim().contains('@')
                            ? AppText.of(
                                context,
                                'أدخل بريدًا إلكترونيًا صالحًا.',
                                'Enter a valid email address.')
                            : null,
                  ),
                const SizedBox(height: 28),
                if (hasEmailAccount) ...[
                  _sectionTitle(
                      context,
                      AppText.of(
                          context, 'تغيير كلمة المرور', 'Change password')),
                  const SizedBox(height: 8),
                  Text(
                    AppText.of(
                        context,
                        'اترك الحقول فارغة إذا لم ترغب بتغييرها.',
                        'Leave these fields empty to keep your current password.'),
                    style: TextStyle(
                        color: context.appPalette.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: _obscurePasswords,
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                      labelText: AppText.of(
                          context, 'كلمة المرور الحالية', 'Current password'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: AppText.of(
                            context, 'إظهار كلمات المرور', 'Show passwords'),
                        onPressed: () => setState(
                            () => _obscurePasswords = !_obscurePasswords),
                        icon: Icon(_obscurePasswords
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscurePasswords,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                      labelText: AppText.of(
                          context, 'كلمة المرور الجديدة', 'New password'),
                      prefixIcon: const Icon(Icons.password_outlined),
                    ),
                    validator: (value) =>
                        value != null && value.isNotEmpty && value.length < 6
                            ? AppText.of(context, 'استخدم 6 أحرف على الأقل.',
                                'Use at least 6 characters.')
                            : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscurePasswords,
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                      labelText: AppText.of(context,
                          'تأكيد كلمة المرور الجديدة', 'Confirm new password'),
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                    ),
                    validator: (value) =>
                        newPassword.isNotEmpty && value != newPassword
                            ? AppText.of(context, 'كلمتا المرور غير متطابقتين.',
                                'Passwords do not match.')
                            : null,
                  ),
                ],
                const SizedBox(height: 28),
                PrimaryButton(
                  label: AppText.of(context, 'حفظ التغييرات', 'Save changes'),
                  icon: Icons.check,
                  loading: _loading,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: context.appPalette.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
